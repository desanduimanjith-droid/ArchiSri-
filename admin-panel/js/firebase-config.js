// Firebase Configuration for ArchiSri Admin Panel
// Uses the same Firebase project as the Flutter app

import { initializeApp } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/11.4.0/firebase-firestore.js";

const firebaseConfig = {
  apiKey: "AIzaSyB07msx9D6tNXS9RIOcVUER35hG03reFn0",
  authDomain: "archi-sri-sign-in.firebaseapp.com",
  projectId: "archi-sri-sign-in",
  storageBucket: "archi-sri-sign-in.firebasestorage.app",
  messagingSenderId: "286258998209",
  appId: "1:286258998209:web:a1aff1bfdcf2261eeb5d40"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

export { auth, db };
