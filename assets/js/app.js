// assets/js/app.js

// Include default Phoenix configuration
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

// Configure LiveView
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});
liveSocket.connect();

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Image upload handling
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("upload-form");
  const imageInput = document.getElementById("image-input");
  const submitButton = document.getElementById("submit-button");
  const imagePreviewContainer = document.getElementById(
    "image-preview-container"
  );
  const imagePreview = document.getElementById("image-preview");
  const resultDiv = document.getElementById("result");
  const resultContent = document.getElementById("result-content");
  const loadingDiv = document.getElementById("loading");
  const errorDiv = document.getElementById("error");
  const errorContent = document.getElementById("error-content");

  // File type validation
  const allowedTypes = ["image/jpeg", "image/png", "image/gif"];
  const maxSize = 10 * 1024 * 1024; // 10MB

  // Handle drag and drop
  const dropZone = document.querySelector(".border-dashed");

  ["dragenter", "dragover", "dragleave", "drop"].forEach((eventName) => {
    dropZone.addEventListener(eventName, preventDefaults, false);
  });

  function preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  ["dragenter", "dragover"].forEach((eventName) => {
    dropZone.addEventListener(eventName, highlight, false);
  });

  ["dragleave", "drop"].forEach((eventName) => {
    dropZone.addEventListener(eventName, unhighlight, false);
  });

  function highlight(e) {
    dropZone.classList.add("border-indigo-600");
  }

  function unhighlight(e) {
    dropZone.classList.remove("border-indigo-600");
  }

  dropZone.addEventListener("drop", handleDrop, false);

  function handleDrop(e) {
    const dt = e.dataTransfer;
    const files = dt.files;

    if (files.length > 0) {
      const file = files[0];
      if (validateFile(file)) {
        imageInput.files = files;
        handleImageSelect();
      }
    }
  }

  function validateFile(file) {
    // Check file type
    if (!allowedTypes.includes(file.type)) {
      showError("Please upload a valid image file (JPG, PNG, or GIF)");
      return false;
    }

    // Check file size
    if (file.size > maxSize) {
      showError("File is too large. Please upload an image smaller than 10MB");
      return false;
    }

    return true;
  }

  // Handle file selection
  if (imageInput) {
    imageInput.addEventListener("change", handleImageSelect);
  }

  function handleImageSelect() {
    const file = imageInput.files[0];
    if (file && validateFile(file)) {
      // Enable submit button
      submitButton.disabled = false;

      // Show image preview
      const reader = new FileReader();
      reader.onload = function (e) {
        imagePreview.src = e.target.result;
        imagePreviewContainer.classList.remove("hidden");
      };
      reader.readAsDataURL(file);

      // Hide any previous errors
      errorDiv.classList.add("hidden");
    } else {
      submitButton.disabled = true;
      imagePreviewContainer.classList.add("hidden");
    }
  }

  // Handle form submission
  if (form) {
    form.addEventListener("submit", async (e) => {
      e.preventDefault();

      const file = imageInput.files[0];
      if (!file) {
        showError("Please select an image first");
        return;
      }

      if (!validateFile(file)) {
        return;
      }

      // Hide previous results and errors, show loading
      hideAll();
      loadingDiv.classList.remove("hidden");
      submitButton.disabled = true;

      const formData = new FormData();
      formData.append("image", file);

      try {
        const response = await fetch("/api/upload", {
          method: "POST",
          body: formData,
          headers: {
            "X-CSRF-Token": csrfToken,
          },
        });

        const data = await response.json();

        // Hide loading
        loadingDiv.classList.add("hidden");
        submitButton.disabled = false;

        if (response.ok && data.status === "success") {
          showResult(data.result);
        } else {
          showError(data.error || "Failed to process image");
        }
      } catch (error) {
        console.error("Upload error:", error);
        showError("An error occurred while uploading the image");
      }
    });
  }

  function hideAll() {
    resultDiv.classList.add("hidden");
    errorDiv.classList.add("hidden");
    loadingDiv.classList.add("hidden");
  }

  function showError(message) {
    hideAll();
    errorDiv.classList.remove("hidden");

    // Create error message with icon and styling
    errorContent.innerHTML = `
      <div class="flex flex-col items-center">
        <div class="text-red-800 mb-2 flex items-center">
          <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <span class="font-medium">
            ${
              message.includes("does not appear to contain garbage")
                ? "Invalid Image"
                : "Error"
            }
          </span>
        </div>
        <div class="text-red-700 text-center">
          ${message}
        </div>
      </div>
    `;

    submitButton.disabled = false;
  }

  function showResult(result) {
    hideAll();
    resultDiv.classList.remove("hidden");
    resultContent.innerHTML = formatResult(result);

    // Smooth scroll to results
    resultDiv.scrollIntoView({ behavior: "smooth", block: "nearest" });
  }

  function formatResult(text) {
    return text
      .split("\n")
      .map((line) => {
        if (line.startsWith("Type:")) {
          return `
            <div class="text-gray-800 font-medium flex items-center mb-2">
              <svg class="w-5 h-5 mr-2 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
              ${line}
            </div>`;
        } else if (line.startsWith("Recommendation:")) {
          return `
            <div class="text-gray-700 flex items-start">
              <svg class="w-5 h-5 mr-2 mt-0.5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              ${line}
            </div>`;
        } else if (line.trim() !== "") {
          return `<div class="text-gray-700 ml-7">${line}</div>`;
        }
        return "";
      })
      .filter((line) => line !== "")
      .join("");
  }
});
