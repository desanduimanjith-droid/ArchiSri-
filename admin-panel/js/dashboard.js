// Dashboard Module
// Loads pending registrations and handles verify/reject actions

import { db } from "./firebase-config.js";
import { adminLogout } from "./auth.js";
import {
  collection,
  query,
  where,
  onSnapshot,
  doc,
  updateDoc,
  deleteDoc,
  getDocs,
  orderBy,
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";

// ── State ──
let currentTab = "engineers";
let currentFilter = "pending"; // "pending", "verified", "all"

// ── Stats ──
let stats = {
  engineers: { pending: 0, verified: 0, total: 0 },
  companies: { pending: 0, verified: 0, total: 0 },
};

// ── Initialize Dashboard ──
function initDashboard() {
  // Tab switching
  document.querySelectorAll(".tab-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".tab-btn").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      currentTab = btn.dataset.tab;
      loadRegistrations();
    });
  });

  // Filter switching
  document.querySelectorAll(".filter-btn").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".filter-btn").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      currentFilter = btn.dataset.filter;
      loadRegistrations();
    });
  });

  // Logout
  document.getElementById("logout-btn").addEventListener("click", adminLogout);

  // Load initial data
  loadRegistrations();
  listenToStats();
}

// ── Listen to stats in real-time ──
function listenToStats() {
  // Engineers
  onSnapshot(collection(db, "engineers"), (snapshot) => {
    stats.engineers.total = snapshot.size;
    stats.engineers.pending = 0;
    stats.engineers.verified = 0;
    snapshot.forEach((doc) => {
      const data = doc.data();
      if (data.isVerified === true) stats.engineers.verified++;
      else stats.engineers.pending++;
    });
    updateStatsUI();
  });

  // Companies
  onSnapshot(collection(db, "companies"), (snapshot) => {
    stats.companies.total = snapshot.size;
    stats.companies.pending = 0;
    stats.companies.verified = 0;
    snapshot.forEach((doc) => {
      const data = doc.data();
      if (data.isVerified === true) stats.companies.verified++;
      else stats.companies.pending++;
    });
    updateStatsUI();
  });
}

function updateStatsUI() {
  const totalPending = stats.engineers.pending + stats.companies.pending;
  const totalVerified = stats.engineers.verified + stats.companies.verified;
  const total = stats.engineers.total + stats.companies.total;

  document.getElementById("stat-pending").textContent = totalPending;
  document.getElementById("stat-verified").textContent = totalVerified;
  document.getElementById("stat-engineers").textContent = stats.engineers.total;
  document.getElementById("stat-companies").textContent = stats.companies.total;

  // Update badge on pending filter
  const pendingBadge = document.getElementById("pending-badge");
  if (pendingBadge) {
    pendingBadge.textContent = totalPending;
    pendingBadge.style.display = totalPending > 0 ? "inline-flex" : "none";
  }
}

// ── Load registrations based on current tab/filter ──
function loadRegistrations() {
  const collectionName = currentTab === "engineers" ? "engineers" : "companies";
  const container = document.getElementById("registrations-container");
  container.innerHTML = '<div class="loading-spinner"><div class="spinner"></div><p>Loading registrations...</p></div>';

  let q;
  if (currentFilter === "pending") {
    q = query(collection(db, collectionName), where("isVerified", "==", false));
  } else if (currentFilter === "verified") {
    q = query(collection(db, collectionName), where("isVerified", "==", true));
  } else {
    q = query(collection(db, collectionName));
  }

  onSnapshot(q, (snapshot) => {
    container.innerHTML = "";

    if (snapshot.empty) {
      container.innerHTML = `
        <div class="empty-state">
          <div class="empty-icon">${currentFilter === "pending" ? "✅" : "📋"}</div>
          <h3>No ${currentFilter} registrations</h3>
          <p>${currentFilter === "pending" ? "All registrations have been reviewed!" : "No registrations found with this filter."}</p>
        </div>
      `;
      return;
    }

    snapshot.forEach((docSnap) => {
      const data = docSnap.data();
      const card = createRegistrationCard(docSnap.id, data, currentTab);
      container.appendChild(card);
    });
  });
}

// ── Create a registration card ──
function createRegistrationCard(docId, data, type) {
  const card = document.createElement("div");
  card.className = `registration-card ${data.isVerified ? "verified" : "pending"}`;
  card.id = `card-${docId}`;

  const statusBadge = data.isVerified
    ? '<span class="status-badge status-verified">✓ Verified</span>'
    : '<span class="status-badge status-pending">⏳ Pending</span>';

  const createdAt = data.createdAt
    ? new Date(data.createdAt.seconds * 1000).toLocaleDateString("en-US", {
        year: "numeric",
        month: "short",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
      })
    : "N/A";

  let detailsHTML = "";
  let documentSection = "";

  if (type === "engineers") {
    detailsHTML = `
      <div class="detail-grid">
        <div class="detail-item">
          <span class="detail-label">Full Name</span>
          <span class="detail-value">${escapeHtml(data.fullName || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Email</span>
          <span class="detail-value">${escapeHtml(data.email || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Phone</span>
          <span class="detail-value">${escapeHtml(data.phoneNumber || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Specialization</span>
          <span class="detail-value">${escapeHtml(data.specialization || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Experience</span>
          <span class="detail-value">${escapeHtml(data.yearsOfExperience || "N/A")} years</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Company</span>
          <span class="detail-value">${escapeHtml(data.company || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Rate/Hour</span>
          <span class="detail-value">LKR ${escapeHtml(data.ratePerHour || "N/A")}</span>
        </div>
      </div>
    `;

    // Document preview
    if (data.professionalIdFile) {
      const fileName = data.professionalIdFileName || "document";
      const ext = fileName.split(".").pop().toLowerCase();
      if (["jpg", "jpeg", "png"].includes(ext)) {
        documentSection = `
          <div class="document-section">
            <h4>📄 Professional ID Document</h4>
            <p class="doc-filename">${escapeHtml(fileName)}</p>
            <img src="data:image/${ext === "jpg" ? "jpeg" : ext};base64,${data.professionalIdFile}" 
                 alt="Professional ID" class="doc-preview" onclick="openImageModal(this.src)">
            <button class="btn-download" onclick="downloadBase64File('${data.professionalIdFile}', '${fileName}')">
              ⬇ Download Document
            </button>
          </div>
        `;
      } else {
        documentSection = `
          <div class="document-section">
            <h4>📄 Professional ID Document</h4>
            <p class="doc-filename">${escapeHtml(fileName)}</p>
            <button class="btn-download" onclick="downloadBase64File('${data.professionalIdFile}', '${fileName}')">
              ⬇ Download PDF
            </button>
          </div>
        `;
      }
    }
  } else {
    // Company
    detailsHTML = `
      <div class="detail-grid">
        <div class="detail-item">
          <span class="detail-label">Company Name</span>
          <span class="detail-value">${escapeHtml(data.companyName || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Email</span>
          <span class="detail-value">${escapeHtml(data.email || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Phone</span>
          <span class="detail-value">${escapeHtml(data.phoneNumber || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Construction Type</span>
          <span class="detail-value">${escapeHtml(data.constructionType || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Location</span>
          <span class="detail-value">${escapeHtml(data.location || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Contact Person</span>
          <span class="detail-value">${escapeHtml(data.contactPersonName || "N/A")}</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Experience</span>
          <span class="detail-value">${escapeHtml(data.yearsOfExperience || "N/A")} years</span>
        </div>
        <div class="detail-item">
          <span class="detail-label">Projects</span>
          <span class="detail-value">${escapeHtml(data.projects || "N/A")}</span>
        </div>
        <div class="detail-item detail-full">
          <span class="detail-label">About</span>
          <span class="detail-value">${escapeHtml(data.about || "N/A")}</span>
        </div>
      </div>
    `;

    if (data.registrationCertificateFile) {
      const fileName = data.registrationCertificateFileName || "certificate";
      const ext = fileName.split(".").pop().toLowerCase();
      if (["jpg", "jpeg", "png"].includes(ext)) {
        documentSection = `
          <div class="document-section">
            <h4>📄 Registration Certificate</h4>
            <p class="doc-filename">${escapeHtml(fileName)}</p>
            <img src="data:image/${ext === "jpg" ? "jpeg" : ext};base64,${data.registrationCertificateFile}" 
                 alt="Registration Certificate" class="doc-preview" onclick="openImageModal(this.src)">
            <button class="btn-download" onclick="downloadBase64File('${data.registrationCertificateFile}', '${fileName}')">
              ⬇ Download Document
            </button>
          </div>
        `;
      } else {
        documentSection = `
          <div class="document-section">
            <h4>📄 Registration Certificate</h4>
            <p class="doc-filename">${escapeHtml(fileName)}</p>
            <button class="btn-download" onclick="downloadBase64File('${data.registrationCertificateFile}', '${fileName}')">
              ⬇ Download PDF
            </button>
          </div>
        `;
      }
    }
  }

  const actionButtons = data.isVerified
    ? `<div class="card-actions">
        <button class="btn-action btn-revoke" onclick="revokeRegistration('${currentTab === "engineers" ? "engineers" : "companies"}', '${docId}')">
          🔄 Revoke Verification
        </button>
      </div>`
    : `<div class="card-actions">
        <button class="btn-action btn-verify" onclick="verifyRegistration('${currentTab === "engineers" ? "engineers" : "companies"}', '${docId}')">
          ✅ Verify
        </button>
        <button class="btn-action btn-reject" onclick="rejectRegistration('${currentTab === "engineers" ? "engineers" : "companies"}', '${docId}')">
          ❌ Reject
        </button>
      </div>`;

  card.innerHTML = `
    <div class="card-header">
      <div class="card-title-section">
        <h3 class="card-title">${escapeHtml(type === "engineers" ? (data.fullName || "Unknown") : (data.companyName || "Unknown"))}</h3>
        <span class="card-subtitle">${escapeHtml(type === "engineers" ? (data.specialization || "") : (data.constructionType || ""))}</span>
      </div>
      <div class="card-meta">
        ${statusBadge}
        <span class="card-date">📅 ${createdAt}</span>
      </div>
    </div>
    <div class="card-body">
      ${detailsHTML}
      ${documentSection}
    </div>
    ${actionButtons}
  `;

  return card;
}

// ── Verify a registration ──
window.verifyRegistration = async function (collectionName, docId) {
  if (!confirm("Are you sure you want to VERIFY this registration? The user will be able to sign in to the app.")) return;

  const card = document.getElementById(`card-${docId}`);
  if (card) card.style.opacity = "0.5";

  try {
    await updateDoc(doc(db, collectionName, docId), {
      isVerified: true,
      verifiedAt: new Date(),
    });
    showToast("✅ Registration verified successfully!", "success");
  } catch (error) {
    console.error("Error verifying:", error);
    showToast("❌ Failed to verify. Please try again.", "error");
    if (card) card.style.opacity = "1";
  }
};

// ── Revoke verification ──
window.revokeRegistration = async function (collectionName, docId) {
  if (!confirm("Are you sure you want to REVOKE this verification? The user will no longer be able to sign in.")) return;

  try {
    await updateDoc(doc(db, collectionName, docId), {
      isVerified: false,
      verifiedAt: null,
    });
    showToast("🔄 Verification revoked.", "warning");
  } catch (error) {
    console.error("Error revoking:", error);
    showToast("❌ Failed to revoke. Please try again.", "error");
  }
};

// ── Reject a registration ──
window.rejectRegistration = async function (collectionName, docId) {
  if (!confirm("Are you sure you want to REJECT this registration? This will permanently delete their profile from the database.")) return;

  const card = document.getElementById(`card-${docId}`);
  if (card) card.style.opacity = "0.5";

  try {
    await deleteDoc(doc(db, collectionName, docId));
    showToast("❌ Registration rejected and deleted.", "warning");
  } catch (error) {
    console.error("Error rejecting:", error);
    showToast("❌ Failed to reject. Please try again.", "error");
    if (card) card.style.opacity = "1";
  }
};

// ── Download base64 file ──
window.downloadBase64File = function (base64Data, fileName) {
  const ext = fileName.split(".").pop().toLowerCase();
  let mimeType = "application/octet-stream";
  if (ext === "pdf") mimeType = "application/pdf";
  else if (ext === "jpg" || ext === "jpeg") mimeType = "image/jpeg";
  else if (ext === "png") mimeType = "image/png";

  const byteCharacters = atob(base64Data);
  const byteNumbers = new Array(byteCharacters.length);
  for (let i = 0; i < byteCharacters.length; i++) {
    byteNumbers[i] = byteCharacters.charCodeAt(i);
  }
  const byteArray = new Uint8Array(byteNumbers);
  const blob = new Blob([byteArray], { type: mimeType });

  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = fileName;
  link.click();
  URL.revokeObjectURL(link.href);
};

// ── Open image in modal ──
window.openImageModal = function (src) {
  const modal = document.getElementById("image-modal");
  const img = document.getElementById("modal-image");
  img.src = src;
  modal.style.display = "flex";
};

window.closeImageModal = function () {
  document.getElementById("image-modal").style.display = "none";
};

// ── Toast notification ──
function showToast(message, type = "info") {
  const container = document.getElementById("toast-container");
  const toast = document.createElement("div");
  toast.className = `toast toast-${type}`;
  toast.textContent = message;
  container.appendChild(toast);

  setTimeout(() => {
    toast.classList.add("toast-fade-out");
    setTimeout(() => toast.remove(), 400);
  }, 3500);
}

// ── Escape HTML helper ──
function escapeHtml(text) {
  if (text === null || text === undefined) return "N/A";
  const div = document.createElement("div");
  div.appendChild(document.createTextNode(String(text)));
  return div.innerHTML;
}

export { initDashboard };
