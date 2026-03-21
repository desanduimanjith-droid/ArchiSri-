// Admin Authentication Module
// Handles login, logout, and auth state management

import { auth, db } from "./firebase-config.js";
import {
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";
import {
  doc,
  getDoc,
} from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";

// ── Check if user is an admin ──
async function isAdmin(email) {
  try {
    const adminDoc = await getDoc(doc(db, "admins", email));
    return adminDoc.exists();
  } catch (error) {
    console.error("Error checking admin status:", error);
    return false;
  }
}

// ── Login ──
async function adminLogin(email, password) {
  try {
    // 1. First sign the user in so Firebase allows them to read the database
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    
    // 2. Now check if this email is in the admins collection
    const adminCheck = await isAdmin(email);
    
    if (!adminCheck) {
      // If they are not an admin, sign them out immediately
      await signOut(auth);
      throw new Error("Access denied. This account is not an administrator.");
    }

    return { success: true, user: userCredential.user };
  } catch (error) {
    let message = "Login failed. Please try again.";
    if (error.message === "Access denied. This account is not an administrator.") {
      message = error.message;
    } else if (error.code === "auth/user-not-found") {
      message = "No account found with this email.";
    } else if (error.code === "auth/wrong-password" || error.code === "auth/invalid-credential") {
      message = "Incorrect email or password.";
    } else if (error.code === "auth/too-many-requests") {
      message = "Too many failed attempts. Please wait and try again.";
    } else if (error.code === "auth/network-request-failed") {
      message = "Network error. Check your connection.";
    }
    return { success: false, message };
  }
}

// ── Logout ──
async function adminLogout() {
  try {
    await signOut(auth);
    window.location.href = "index.html";
  } catch (error) {
    console.error("Logout error:", error);
  }
}

// ── Auth state listener for login page ──
function initLoginPage() {
  const form = document.getElementById("login-form");
  const errorDiv = document.getElementById("login-error");
  const submitBtn = document.getElementById("login-btn");
  const spinner = document.getElementById("login-spinner");
  const btnText = document.getElementById("login-btn-text");

  // If already logged in as admin, redirect to dashboard
  onAuthStateChanged(auth, async (user) => {
    if (user) {
      const adminCheck = await isAdmin(user.email);
      if (adminCheck) {
        window.location.href = "dashboard.html";
      }
    }
  });

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    errorDiv.style.display = "none";
    submitBtn.disabled = true;
    spinner.style.display = "inline-block";
    btnText.textContent = "Signing in...";

    const email = document.getElementById("admin-email").value.trim();
    const password = document.getElementById("admin-password").value;

    const result = await adminLogin(email, password);

    if (result.success) {
      window.location.href = "dashboard.html";
    } else {
      errorDiv.textContent = result.message;
      errorDiv.style.display = "block";
      submitBtn.disabled = false;
      spinner.style.display = "none";
      btnText.textContent = "Sign In";
    }
  });
}

// ── Auth state listener for dashboard page ──
function initDashboardAuth() {
  return new Promise((resolve, reject) => {
    onAuthStateChanged(auth, async (user) => {
      if (!user) {
        window.location.href = "index.html";
        reject("Not authenticated");
        return;
      }
      const adminCheck = await isAdmin(user.email);
      if (!adminCheck) {
        await signOut(auth);
        window.location.href = "index.html";
        reject("Not an admin");
        return;
      }
      // Set admin name in the header
      const adminNameEl = document.getElementById("admin-name");
      if (adminNameEl) {
        adminNameEl.textContent = user.email;
      }
      resolve(user);
    });
  });
}

export { adminLogin, adminLogout, initLoginPage, initDashboardAuth };
