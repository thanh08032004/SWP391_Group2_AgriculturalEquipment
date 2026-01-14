/* 
Name                 : Panelry – Task, Project, CRM & SaaS Admin Dashboard Template
Author               : Panelry
Url                  : https://www.templaterise.com/template/panelry-task-project-crm-saas-admin-dashboard-template
*/

// ================================
// DOM ELEMENTS
// ================================
const hambBtn = document.getElementById("hambBtn");
const sidebar = document.getElementById("sidebar");
const collapseBtn = document.getElementById("collapseBtn");

const themeToggle = document.getElementById("themeToggle");
const themeIcon = document.getElementById("themeIcon");

const colorOptions = document.querySelectorAll(".color-option");
const primaryColorPicker = document.getElementById("primaryColorPicker");
const secondaryColorPicker = document.getElementById("secondaryColorPicker");
const bgColorPicker = document.getElementById("bgColorPicker");
const resetBtn = document.getElementById("resetBtn");

const styleTab = document.getElementById("styleTab");
const colorTab = document.getElementById("colorTab");

const filterBtns = document.querySelectorAll(".filter-btn");
const projectsGrid = document.getElementById("projectsGrid");
const emptyState = document.getElementById("emptyState");
const projectCards = document.querySelectorAll(".project-card");

// File upload (FIXED)
const fileUpload = document.getElementById("fileUpload");
const fileInput = document.getElementById("fileInput");
const fileList = document.getElementById("fileList");

const tabBtns = document.querySelectorAll(".tab-btn");
const tabContents = document.querySelectorAll(".tab-content");
const milestoneCheckboxes = document.querySelectorAll(".milestone-checkbox");

// Tasks Tab Elements
const taskFilterBtns = document.querySelectorAll(".tasks-filters .filter-btn");
const taskRows = document.querySelectorAll(".task-row");
const taskCheckboxes = document.querySelectorAll(".task-checkbox");

// Files Tab Elements
const fileFilterBtns = document.querySelectorAll(".file-filter-btn");
const fileCards = document.querySelectorAll(".file-card");

const listViewBtn = document.getElementById("listViewBtn");
const gridViewBtn = document.getElementById("gridViewBtn");
const listView = document.getElementById("listView");
const gridView = document.getElementById("gridView");
const addSkillBtn = document.getElementById("addSkillBtn");
const newSkillInput = document.getElementById("newSkillInput");
const showPasswordBtn = document.getElementById("showPasswordBtn");

addAssignmentBtn = document.getElementById("addAssignmentBtn");

let searchTerm = "";

// ================================
// GLOBAL STATE
// ================================
let selectedTeamMembers = [];
let currentFilter = "all";
let currentSearch = "";
let currentView = "list";

let skills = ["UI Design", "User Research", "Prototyping"];
let avatarFile = null;
let avatarPreviewUrl = null;

// ================================
// THEME MANAGER
// ================================
class ThemeManager {
  constructor() {
    this.prefersDark = window.matchMedia("(prefers-color-scheme: dark)");
    this.init();
  }

  init() {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme) {
      document.body.classList.toggle("dark-mode", savedTheme === "dark");
    } else {
      this.setSystemTheme();
    }
    this.updateThemeIcon();
    this.setupListeners();
  }

  setSystemTheme() {
    const isDark = this.prefersDark.matches;
    document.body.classList.toggle("dark-mode", isDark);
    localStorage.setItem("theme", isDark ? "dark" : "light");
  }

  toggleTheme() {
    const isDark = document.body.classList.toggle("dark-mode");
    localStorage.setItem("theme", isDark ? "dark" : "light");
    this.updateThemeIcon();
  }

  updateThemeIcon() {
    if (!themeIcon) return;
    const path = themeIcon.querySelector("path");
    if (!path) return;

    path.setAttribute(
      "d",
      document.body.classList.contains("dark-mode")
        ? "M21 12.79A9 9 0 1111.21 3 7 7 0 0021 12.79z"
        : "M12 17a5 5 0 100-10 5 5 0 000 10zM12 3v2M12 19v2M5 12H3M21 12h-2M6.34 6.34l-1.41 1.41M19.07 19.07l-1.41 1.41"
    );
  }

  setupListeners() {
    this.prefersDark.addEventListener("change", () => {
      if (!localStorage.getItem("theme")) this.setSystemTheme();
    });
  }
}

const themeManager = new ThemeManager();

function hexToRgb(hex) {
  const r = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return r
    ? { r: parseInt(r[1], 16), g: parseInt(r[2], 16), b: parseInt(r[3], 16) }
    : null;
}

// ================================
// HEADER / SIDEBAR
// ================================
themeToggle?.addEventListener("click", () => themeManager.toggleTheme());

hambBtn?.addEventListener("click", () => sidebar?.classList.toggle("show"));

collapseBtn?.addEventListener("click", () => {
  const collapsed = sidebar?.classList.toggle("collapsed");
  collapseBtn.setAttribute("aria-pressed", collapsed);
  collapseBtn.querySelector("svg").style.transform = collapsed
    ? "rotate(180deg)"
    : "rotate(0deg)";
});

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    closeAll();
    sidebar?.classList.remove("show");
  }
});

// ================================
// SIDEBAR SUBMENU
// ================================
document.querySelectorAll(".has-submenu > .menu-link").forEach((link) => {
  link.addEventListener("click", (e) => {
    e.preventDefault();
    const submenu = link.parentElement.querySelector(".submenu");
    const arrow = link.querySelector(".arrow");
    const open = submenu.style.display === "block";
    submenu.style.display = open ? "none" : "block";
    arrow.style.transform = open ? "rotate(0deg)" : "rotate(90deg)";
  });
});

// ================================
// COLORS & STYLES
// ================================
colorOptions.forEach((btn) => {
  btn.addEventListener("click", () => {
    const target = btn.dataset.target;
    const color = btn.dataset.color;

    document
      .querySelectorAll(`[data-target="${target}"]`)
      .forEach((b) => b.classList.remove("selected"));

    btn.classList.add("selected");

    document.documentElement.style.setProperty(
      target === "menu" ? "--sidebar-bg" : "--navbar-bg",
      color
    );
  });
});

primaryColorPicker?.addEventListener("input", (e) => {
  const rgb = hexToRgb(e.target.value);
  document.documentElement.style.setProperty("--accent", e.target.value);
  if (rgb)
    document.documentElement.style.setProperty(
      "--accent-rgb",
      `${rgb.r}, ${rgb.g}, ${rgb.b}`
    );
});

secondaryColorPicker?.addEventListener("input", (e) =>
  document.documentElement.style.setProperty("--accent-2", e.target.value)
);

bgColorPicker?.addEventListener("input", (e) =>
  document.documentElement.style.setProperty("--bg", e.target.value)
);

resetBtn?.addEventListener("click", () => {
  document.documentElement.style.cssText = "";
  document.body.classList.remove("dark-mode");
  localStorage.setItem("theme", "light");
  themeManager.updateThemeIcon();
});

// ================================
// TABS
// ================================
styleTab?.addEventListener("click", () => {
  styleTab.classList.add("active");
  colorTab.classList.remove("active");
});

colorTab?.addEventListener("click", () => {
  colorTab.classList.add("active");
  styleTab.classList.remove("active");
});

// ================================
// TEAM MEMBERS
// ================================
document.querySelectorAll(".team-member").forEach((member) => {
  member.addEventListener("click", function () {
    const id = this.dataset.id;
    this.classList.toggle("selected");

    if (selectedTeamMembers.includes(id)) {
      selectedTeamMembers = selectedTeamMembers.filter((i) => i !== id);
    } else {
      selectedTeamMembers.push(id);
    }
  });
});

// ================================
// FILE UPLOAD (FIXED)
// ================================
if (fileUpload && fileInput && fileList) {
  fileUpload.addEventListener("click", () => fileInput.click());

  fileInput.addEventListener("change", () => {
    fileList.innerHTML = "";

    [...fileInput.files].forEach((file, index) => {
      const el = document.createElement("div");
      el.className =
        "d-flex justify-content-between align-items-center mb-2 p-2 bg-hover rounded";

      el.innerHTML = `
        <span>${file.name} (${(file.size / 1024 / 1024).toFixed(2)} MB)</span>
        <button class="btn btn-sm btn-outline-danger">
          <i class="bi bi-x"></i>
        </button>
      `;

      el.querySelector("button").addEventListener("click", () =>
        removeFile(index)
      );
      fileList.appendChild(el);
    });
  });
}

function removeFile(index) {
  const dt = new DataTransfer();
  [...fileInput.files].forEach((f, i) => i !== index && dt.items.add(f));
  fileInput.files = dt.files;
  fileInput.dispatchEvent(new Event("change"));
}

filterBtns.forEach((btn) => {
  btn.addEventListener("click", () => {
    filterBtns.forEach((b) => b.classList.remove("active"));
    btn.classList.add("active");
    currentFilter = btn.dataset.filter;
    // filterProjects();
  });
});

tabBtns.forEach((btn) => {
  btn.addEventListener("click", function () {
    const tabId = this.getAttribute("data-tab");

    // Update active tab button
    tabBtns.forEach((b) => b.classList.remove("active"));
    this.classList.add("active");

    // Show corresponding tab content
    tabContents.forEach((content) => {
      content.classList.remove("active");
      if (content.id === tabId + "Tab") {
        content.classList.add("active");
      }
    });
  });
});

// Milestone completion toggle
milestoneCheckboxes.forEach((checkbox) => {
  checkbox.addEventListener("click", function () {
    this.classList.toggle("completed");
    const milestoneTitle =
      this.closest(".milestone-item").querySelector(".milestone-title");

    if (this.classList.contains("completed")) {
      milestoneTitle.style.textDecoration = "line-through";
      milestoneTitle.style.opacity = "0.7";
    } else {
      milestoneTitle.style.textDecoration = "none";
      milestoneTitle.style.opacity = "1";
    }
  });
});

// Task completion toggle
taskCheckboxes.forEach((checkbox) => {
  checkbox.addEventListener("click", function () {
    this.classList.toggle("completed");
    const taskRow = this.closest(".task-row");
    const taskTitle = taskRow.querySelector(".task-title-cell");
    const statusBadge = taskRow.querySelector(".task-status");

    if (this.classList.contains("completed")) {
      taskTitle.style.textDecoration = "line-through";
      taskTitle.style.opacity = "0.7";
      statusBadge.textContent = "Completed";
      statusBadge.className = "task-status status-completed";
      taskRow.setAttribute("data-status", "completed");
    } else {
      taskTitle.style.textDecoration = "none";
      taskTitle.style.opacity = "1";
      statusBadge.textContent = "To Do";
      statusBadge.className = "task-status status-todo";
      taskRow.setAttribute("data-status", "todo");
    }
  });
});

fileFilterBtns.forEach((btn) => {
  btn.addEventListener("click", function () {
    fileFilterBtns.forEach((b) => b.classList.remove("active"));
    this.classList.add("active");
  });
});

function switchView(view) {
  currentView = view;

  // Update active view button
  listViewBtn.classList.toggle("active", view === "list");
  gridViewBtn.classList.toggle("active", view === "grid");

  // Show/hide views
  if (view === "list") {
    listView.style.display = "block";
    gridView.style.display = "none";
  } else {
    listView.style.display = "none";
    gridView.style.display = "block";
  }
}

if (listViewBtn && gridViewBtn) {
  listViewBtn.addEventListener("click", () => switchView("list"));
  gridViewBtn.addEventListener("click", () => switchView("grid"));
}

let selectedAssigneeIds = [];
// Initialize Select2 for assignee selection
function initializeSelect2() {
  if ($(".select2-assignee").length > 0) {
    $(".select2-assignee").select2({
      theme: "default",
      width: "100%",
      placeholder: "Select team members...",
      allowClear: true,
      multiple: true,
      closeOnSelect: false,
      templateResult: formatAssigneeOption,
      templateSelection: formatAssigneeSelection,
      escapeMarkup: function (m) {
        return m;
      },
    });

    // Update selectedAssigneeIds when selection changes
    $(".select2-assignee").on("change", function () {
      selectedAssigneeIds = $(this).val() || [];
    });
  }
}

// Format assignee option in dropdown
function formatAssigneeOption(assignee) {
  if (!assignee.id) {
    return assignee.text;
  }

  const avatarBg = $(assignee.element).data("avatar-bg");
  const avatarText = $(assignee.element).data("avatar-text");
  const assigneeText = assignee.text;

  const $option = $(
    '<div class="assignee-option-select2">' +
      '<div class="assignee-avatar-select2" style="background: ' +
      avatarBg +
      '">' +
      avatarText +
      "</div>" +
      "<span>" +
      assigneeText +
      "</span>" +
      "</div>"
  );

  return $option;
}

// Format selected assignee in the input
function formatAssigneeSelection(assignee) {
  if (!assignee.id) {
    return assignee.text;
  }

  const avatarBg = $(assignee.element).data("avatar-bg");
  const avatarText = $(assignee.element).data("avatar-text");
  const assigneeText = assignee.text;

  // Extract just the name (remove role)
  const nameOnly = assigneeText.split("(")[0].trim();

  const $selection = $(
    '<div class="assignee-option-select2">' +
      '<div class="assignee-avatar-select2" style="background: ' +
      avatarBg +
      '">' +
      avatarText +
      "</div>" +
      "<span>" +
      nameOnly +
      "</span>" +
      "</div>"
  );

  return $selection;
}

// Get assignee names from selected IDs
function getSelectedAssigneeNames() {
  const selectedNames = [];
  $(".select2-assignee option:selected").each(function () {
    const fullText = $(this).text();
    // Extract name (remove role in parentheses)
    const name = fullText.split("(")[0].trim();
    selectedNames.push(name);
  });
  return selectedNames;
}

initializeSelect2();

// Get avatar initials
function getAvatarInitials(firstName, lastName) {
  return ((firstName?.[0] || "") + (lastName?.[0] || "")).toUpperCase();
}

// Update avatar preview
function updateAvatarPreview() {
  const firstName = document.getElementById("firstName").value;
  const lastName = document.getElementById("lastName").value;
  const avatarPreview = document.getElementById("avatarPreview");

  if (avatarPreviewUrl) {
    avatarPreview.innerHTML = `<img src="${avatarPreviewUrl}" alt="Avatar">`;
  } else {
    const initials = getAvatarInitials(firstName, lastName) || "JD";
    avatarPreview.innerHTML = `<span>${initials}</span>`;
  }
}

// Avatar upload handling
if (document.getElementById("avatarInput")) {
  document
    .getElementById("avatarInput")
    .addEventListener("change", function (e) {
      const file = e.target.files[0];
      if (file) {
        if (file.size > 2 * 1024 * 1024) {
          alert("File size must be less than 2MB");
          return;
        }

        const reader = new FileReader();
        reader.onload = function (e) {
          avatarPreviewUrl = e.target.result;
          updateAvatarPreview();
        };
        reader.readAsDataURL(file);
        avatarFile = file;
      }
    });
}

// Update avatar when name changes

if (
  document.getElementById("firstName") &&
  document.getElementById("lastName")
) {
  document
    .getElementById("firstName")
    .addEventListener("input", updateAvatarPreview);
  document
    .getElementById("lastName")
    .addEventListener("input", updateAvatarPreview);
}

// Add new department assignment
if (addAssignmentBtn) {
  addAssignmentBtn.addEventListener("click", function () {
    const container = document.getElementById("assignmentsContainer");
    const newItem = document.createElement("div");
    newItem.className = "assignment-item";
    newItem.innerHTML = `
                  <div class="assignment-details">
                      <select class="department-select" name="department[]">
                          <option value="">Select Department</option>
                          <option value="design">Design Team</option>
                          <option value="development">Development</option>
                          <option value="product">Product Management</option>
                          <option value="marketing">Marketing</option>
                          <option value="sales">Sales</option>
                          <option value="support">Customer Support</option>
                          <option value="operations">Operations</option>
                          <option value="hr">Human Resources</option>
                          <option value="finance">Finance</option>
                      </select>
                      <select class="role-select" name="role[]">
                          <option value="">Select Role</option>
                          <option value="member">Team Member</option>
                          <option value="lead">Team Lead</option>
                          <option value="manager">Manager</option>
                          <option value="director">Director</option>
                          <option value="contributor">Contributor</option>
                          <option value="reviewer">Reviewer</option>
                          <option value="approver">Approver</option>
                          <option value="observer">Observer</option>
                      </select>
                  </div>
                  <button type="button" class="remove-assignment" onclick="removeAssignment(this)">
                      <i class="bi bi-trash"></i>
                  </button>
              `;
    container.appendChild(newItem);
  });
}

// Remove department assignment
function removeAssignment(button) {
  const container = document.getElementById("assignmentsContainer");
  if (container.children.length > 1) {
    button.closest(".assignment-item").remove();
  } else {
    // If it's the last item, reset it instead of removing
    const item = button.closest(".assignment-item");
    item.querySelector(".department-select").value = "";
    item.querySelector(".role-select").value = "";
    item.querySelector(".form-control").value = "";
  }
}

// Add new skill
if (addSkillBtn && newSkillInput) {
  addSkillBtn.addEventListener("click", addSkill);
  newSkillInput.addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
      e.preventDefault();
      addSkill();
    }
  });
}

function addSkill() {
  const skillText = newSkillInput.value.trim();

  if (skillText && !skills.includes(skillText)) {
    skills.push(skillText);
    renderSkills();
    newSkillInput.value = "";
    newSkillInput.focus();
  }
}

// Render skills
function renderSkills() {
  const container = document.getElementById("skillsContainer");
  container.innerHTML = "";

  skills.forEach((skill) => {
    const span = document.createElement("span");
    span.className = "skill-tag";
    span.innerHTML = `
                    ${skill}
                    <button type="button" class="remove" data-skill="${skill}">
                        <i class="bi bi-x"></i>
                    </button>
                `;
    container.appendChild(span);

    span.querySelector(".remove").addEventListener("click", function () {
      const skillToRemove = this.getAttribute("data-skill");
      skills = skills.filter((s) => s !== skillToRemove);
      renderSkills();
    });
  });
}

// Initialize skill remove buttons
document.querySelectorAll(".skill-tag .remove").forEach((btn) => {
  btn.addEventListener("click", function () {
    const skillToRemove = this.getAttribute("data-skill");
    skills = skills.filter((s) => s !== skillToRemove);
    renderSkills();
  });
});

// Show/hide password
if (showPasswordBtn) {
  showPasswordBtn.addEventListener("click", function () {
    const passwordInput = document.getElementById("password");
    const type =
      passwordInput.getAttribute("type") === "password" ? "text" : "password";
    passwordInput.setAttribute("type", type);
    this.innerHTML =
      type === "password"
        ? '<i class="bi bi-eye"></i>'
        : '<i class="bi bi-eye-slash"></i>';
  });
}

function initializeCharts() {

  const performanceCanvas = document.getElementById("performanceChart");
  if (performanceCanvas) {
    const performanceCtx = performanceCanvas.getContext("2d");
    performanceChart = new Chart(performanceCtx, {
      type: "line",
      data: {
        labels: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],
        datasets: [
          {
            label: "Task Completion",
            data: [65,70,75,80,85,82,88,90,87,92,95,98],
            tension: 0.4,
            fill: true,
          },
          {
            label: "Project Progress",
            data: [40,45,55,60,70,75,80,85,82,88,90,95],
            tension: 0.4,
            fill: true,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
      },
    });
  }

  const categoryCanvas = document.getElementById("categoryChart");
  if (categoryCanvas) {
    const categoryCtx = categoryCanvas.getContext("2d");
    categoryChart = new Chart(categoryCtx, {
      type: "doughnut",
      data: {
        labels: ["Performance","Financial","Project","Team","Task","Custom"],
        datasets: [
          {
            data: [24,18,32,15,42,8],
            borderWidth: 2,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: "right",
            labels: {
              padding: 20,
            },
          },
        },
      },
    });
  }
}


initializeCharts();

// Settings Navigation Functionality
function setupSettingsNavigation() {
  const settingsNavLinks = document.querySelectorAll(".settings-nav-link");
  const settingsSections = document.querySelectorAll(".settings-section");

  settingsNavLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
      e.preventDefault();

      // Get the target section from data-section attribute
      const targetSectionId = this.getAttribute("data-section");

      // Remove active class from all nav links
      settingsNavLinks.forEach((l) => {
        l.classList.remove("active");
      });

      // Add active class to clicked link
      this.classList.add("active");

      // Hide all sections
      settingsSections.forEach((section) => {
        section.classList.remove("active");
      });

      // Show target section
      const targetSection = document.getElementById(`${targetSectionId}`);
      if (targetSection) {
        targetSection.classList.add("active");
      } else {
      }
    });
  });

  // Initialize with first section active
  if (settingsNavLinks.length > 0 && settingsSections.length > 0) {
    settingsNavLinks[0].classList.add("active");
    settingsSections[0].classList.add("active");
  }
}

setupSettingsNavigation();

document.querySelectorAll(".radio-card").forEach((card) => {
  card.addEventListener("click", function () {
    document.querySelectorAll(".radio-card").forEach((c) => {
      c.classList.remove("selected");
    });
    this.classList.add("selected");
  });
});

function setTheme(theme) {
  if (theme === "auto") {
    localStorage.removeItem("theme");
    themeManager.setSystemTheme();
  } else {
    document.body.classList.toggle("dark-mode", theme === "dark");
    localStorage.setItem("theme", theme);
    themeManager.updateThemeIcon();
  }

  // Update radio buttons
  document.querySelectorAll('input[name="theme"]').forEach((radio) => {
    radio.checked = false;
  });
  if (theme === "light") {
    document.querySelector('input[name="theme"][value="light"]').checked = true;
  } else if (theme === "dark") {
    document.querySelector('input[name="theme"][value="dark"]').checked = true;
  } else {
    document.querySelector('input[name="theme"][value="auto"]').checked = true;
  }
}

// DOM Elements

const mailSidebar = document.getElementById("mailSidebar");
const mailListView = document.getElementById("mailListView");
const emailView = document.getElementById("emailView");
const mailList = document.getElementById("mailList");
const MailsearchInput = document.getElementById("MailsearchInput");
const composeModal = document.getElementById("composeModal");

// Sample Email Data
const emails = [
  {
    id: 1,
    sender: { name: "John Doe", email: "john@template.com", avatar: "JD" },
    subject: "Project Update: Q4 Planning",
    preview:
      "Hi team, I've attached the Q4 planning document for review. Please provide feedback by Friday.",
    time: "10:30 AM",
    date: "Today",
    unread: true,
    starred: true,
    important: true,
    labels: ["work", "projects"],
    attachments: 2,
    folder: "inbox",
    body: `
                    <p>Hi team,</p>
                    <p>I hope this email finds you well. I've attached the Q4 planning document for your review. This includes our strategic objectives, key projects, and resource allocation for the next quarter.</p>
                    <p>Key highlights:</p>
                    <ul>
                        <li>Launch of new product features</li>
                        <li>Marketing campaign for holiday season</li>
                        <li>Team expansion plans</li>
                        <li>Budget allocation breakdown</li>
                    </ul>
                    <p>Please review the attached document and provide your feedback by Friday, December 20th. We'll discuss this in our weekly meeting.</p>
                    <p>Best regards,<br>John</p>
                `,
    attachmentsList: [
      { name: "Q4_Planning_Document.pdf", size: "2.4 MB", type: "pdf" },
      { name: "Budget_Allocation.xlsx", size: "1.8 MB", type: "excel" },
    ],
  },
  {
    id: 2,
    sender: { name: "Sarah Chen", email: "sarah@company.com", avatar: "SC" },
    subject: "Meeting Invitation: Design Review",
    preview:
      "You're invited to a design review meeting on Thursday at 2 PM in Conference Room B.",
    time: "Yesterday, 3:45 PM",
    date: "Dec 14",
    unread: true,
    starred: false,
    important: true,
    labels: ["work", "projects"],
    attachments: 1,
    folder: "inbox",
    body: `
          <p>Hello everyone,</p>
          <p>You are cordially invited to our design review meeting scheduled for Thursday, December 19th at 2:00 PM in Conference Room B.</p>
          <p>Agenda:</p>
          <ol>
              <li>Review of new UI/UX designs</li>
              <li>Feedback on mobile responsiveness</li>
              <li>Discussion on design system updates</li>
              <li>Q&A session</li>
          </ol>
          <p>Please come prepared with your feedback and suggestions. The design mockups are attached for your reference.</p>
          <p>Looking forward to seeing you there!</p>
          <p>Best,<br>Sarah</p>
                `,
    attachmentsList: [
      { name: "Design_Mockups.zip", size: "4.2 MB", type: "zip" },
    ],
  },
  {
    id: 3,
    sender: { name: "Mike Johnson", email: "mike@techcorp.com", avatar: "MJ" },
    subject: "Your subscription is about to expire",
    preview:
      "Your annual subscription to TechCorp Pro is set to expire in 7 days. Renew now to continue...",
    time: "Dec 12, 11:20 AM",
    date: "Dec 12",
    unread: false,
    starred: false,
    important: false,
    labels: ["finance"],
    attachments: 0,
    folder: "inbox",
    body: `
                    <p>Dear Customer,</p>
                    <p>This is a reminder that your annual subscription to TechCorp Pro is set to expire in 7 days.</p>
                    <p>To continue enjoying all the benefits of your subscription, please renew before the expiration date. Your current plan includes:</p>
                    <ul>
                        <li>Unlimited project management</li>
                        <li>Advanced analytics</li>
                        <li>Priority support</li>
                        <li>Team collaboration tools</li>
                    </ul>
                    <p>Renew now to avoid any interruption in service. You can renew your subscription by clicking the link below or visiting your account dashboard.</p>
                    <p><a href="#" style="color: var(--accent); text-decoration: none; font-weight: 600;">Renew Subscription</a></p>
                    <p>If you have any questions, please don't hesitate to contact our support team.</p>
                    <p>Best regards,<br>Mike Johnson<br>Customer Success Team</p>
                `,
  },
  {
    id: 4,
    sender: { name: "Lisa Rodriguez", email: "lisa@design.com", avatar: "LR" },
    subject: "Feedback on your recent work",
    preview:
      "Great job on the dashboard redesign! I have some minor feedback that I'd like to share...",
    time: "Dec 11, 4:30 PM",
    date: "Dec 11",
    unread: false,
    starred: true,
    important: false,
    labels: ["work"],
    attachments: 0,
    folder: "inbox",
    body: `
                    <p>Hi there,</p>
                    <p>I wanted to reach out and say great job on the dashboard redesign! The new layout is much more intuitive and the color scheme works really well.</p>
                    <p>I do have some minor feedback that I'd like to share:</p>
                    <ul>
                        <li>The navigation could be slightly more prominent</li>
                        <li>Consider adding a dark mode toggle</li>
                        <li>The charts could use better contrast for accessibility</li>
                    </ul>
                    <p>Overall, excellent work! Let's schedule a quick call to discuss these points further.</p>
                    <p>Cheers,<br>Lisa</p>
                `,
  },
  {
    id: 5,
    sender: {
      name: "Travel Agency",
      email: "noreply@travelagency.com",
      avatar: "TA",
    },
    subject: "Your flight booking confirmation",
    preview:
      "Your flight from San Francisco to New York has been confirmed. Booking reference: TA-789456",
    time: "Dec 10, 9:15 AM",
    date: "Dec 10",
    unread: false,
    starred: false,
    important: false,
    labels: ["travel"],
    attachments: 1,
    folder: "inbox",
    body: `
                    <p>Dear Traveler,</p>
                    <p>Your flight booking has been confirmed! Here are your travel details:</p>
                    <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
                        <tr>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);"><strong>Flight:</strong></td>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);">SF123 • San Francisco (SFO) to New York (JFK)</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);"><strong>Date:</strong></td>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);">December 28, 2025</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);"><strong>Time:</strong></td>
                            <td style="padding: 8px; border-bottom: 1px solid var(--border);">Departure: 8:00 AM • Arrival: 4:30 PM</td>
                        </tr>
                        <tr>
                            <td style="padding: 8px;"><strong>Booking Ref:</strong></td>
                            <td style="padding: 8px;">TA-789456</td>
                        </tr>
                    </table>
                    <p>Please arrive at the airport at least 2 hours before departure. Your boarding pass will be available 24 hours before the flight.</p>
                    <p>Safe travels!<br>The Travel Agency Team</p>
                `,
    attachmentsList: [
      { name: "Flight_Itinerary.pdf", size: "1.2 MB", type: "pdf" },
    ],
  },
  {
    id: 6,
    sender: { name: "David Wilson", email: "david@finance.com", avatar: "DW" },
    subject: "Quarterly financial report ready",
    preview:
      "The Q3 financial report is now available for review. Key metrics show 15% growth...",
    time: "Dec 9, 2:00 PM",
    date: "Dec 9",
    unread: false,
    starred: true,
    important: true,
    labels: ["work", "finance"],
    attachments: 2,
    folder: "inbox",
    body: `
                    <p>Hello Team,</p>
                    <p>The Q3 financial report is now available for review. I'm pleased to share that we've achieved 15% growth compared to the previous quarter.</p>
                    <p>Key highlights:</p>
                    <ul>
                        <li>Revenue increased by 15%</li>
                        <li>Profit margin improved by 8%</li>
                        <li>Customer acquisition cost decreased by 12%</li>
                        <li>New markets expanded successfully</li>
                    </ul>
                    <p>The detailed report is attached, including breakdowns by department, product line, and region. Please review and let me know if you have any questions.</p>
                    <p>We'll discuss this in detail at the upcoming board meeting.</p>
                    <p>Regards,<br>David</p>
                `,
    attachmentsList: [
      { name: "Q3_Financial_Report.pdf", size: "3.8 MB", type: "pdf" },
      { name: "Financial_Data.xlsx", size: "2.1 MB", type: "excel" },
    ],
  },
];

// Selected emails
let selectedEmails = new Set();
let currentFolder = "inbox";
let currentEmailId = null;
let filteredEmails = [...emails];
let actionsDropdown = null;
let actionsDropdownBtn = null;

// Load emails
function loadEmails() {
  if (!mailList) return;

  // Filter emails by current folder
  filteredEmails = emails.filter((email) => email.folder === currentFolder);

  // Apply search filter if any

  if(MailsearchInput){
    const searchTerm = MailsearchInput.value.toLowerCase();

    if (searchTerm) {
    filteredEmails = filteredEmails.filter(
      (email) =>
        email.subject.toLowerCase().includes(searchTerm) ||
        email.preview.toLowerCase().includes(searchTerm) ||
        email.sender.name.toLowerCase().includes(searchTerm) ||
        email.sender.email.toLowerCase().includes(searchTerm)
    );
  }


  }

  
  // Clear selected emails
  selectedEmails.clear();

  // Render emails
  if (filteredEmails.length === 0) {
    mailList.innerHTML = `
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="bi bi-envelope"></i>
                    </div>
                    <div class="empty-title">No emails found</div>
                    <div class="empty-description">
                        ${
                          searchTerm
                            ? "No emails match your search. Try different keywords."
                            : "Your inbox is empty. Start by composing a new email!"
                        }
                    </div>
                </div>
            `;
  } else {
    mailList.innerHTML = filteredEmails
      .map((email) => {
        const unreadClass = email.unread ? "unread" : "";
        const selectedClass = selectedEmails.has(email.id) ? "selected" : "";
        const checkedClass = selectedEmails.has(email.id) ? "checked" : "";
        const starredClass = email.starred ? "starred" : "";

        return `
                    <div class="mail-item ${unreadClass} ${selectedClass}" data-id="${
          email.id
        }">
                        <div class="mail-checkbox ${checkedClass}" onclick="toggleSelect(${
          email.id
        }, event)">
                            ${checkedClass ? '<i class="bi bi-check"></i>' : ""}
                        </div>
                        <div class="mail-star ${starredClass}" onclick="toggleStar(${
          email.id
        })">
                            <i class="bi bi-star${
                              starredClass ? "-fill" : ""
                            }"></i>
                        </div>
                        <div class="mail-sender" onclick="viewEmail(${
                          email.id
                        })">
                            <div class="sender-avatar">${
                              email.sender.avatar
                            }</div>
                            <div class="sender-name">${email.sender.name}</div>
                        </div>
                        <div class="mail-content" onclick="viewEmail(${
                          email.id
                        })">
                            <div class="mail-subject">${email.subject}</div>
                            <div class="mail-preview">${email.preview}</div>
                            ${
                              email.labels && email.labels.length > 0
                                ? `
                                <div class="mail-labels-container">
                                    ${email.labels
                                      .map(
                                        (label) => `
                                        <span class="mail-label" style="background: ${getLabelColor(
                                          label
                                        )}; color: white;">${label}</span>
                                    `
                                      )
                                      .join("")}
                                </div>
                            `
                                : ""
                            }
                        </div>
                        <div class="mail-meta">
                            ${
                              email.attachments > 0
                                ? `
                                <div class="mail-attachment">
                                    <i class="bi bi-paperclip"></i>
                                </div>
                            `
                                : ""
                            }
                            <div class="mail-time">
                                ${
                                  email.date === "Today"
                                    ? email.time
                                    : email.date
                                }
                            </div>
                        </div>
                    </div>
                `;
      })
      .join("");
  }
}

// Get label color
function getLabelColor(label) {
  const colors = {
    work: "var(--accent)",
    personal: "var(--success)",
    travel: "var(--warning)",
    finance: "var(--danger)",
    projects: "var(--info)",
  };
  return colors[label] || "var(--accent)";
}

// Toggle email selection
function toggleSelect(emailId, event) {
  event.stopPropagation();

  if (selectedEmails.has(emailId)) {
    selectedEmails.delete(emailId);
  } else {
    selectedEmails.add(emailId);
  }

  // Update UI
  const mailItem = document.querySelector(`.mail-item[data-id="${emailId}"]`);
  const checkbox = mailItem.querySelector(".mail-checkbox");

  if (selectedEmails.has(emailId)) {
    mailItem.classList.add("selected");
    checkbox.classList.add("checked");
    checkbox.innerHTML = '<i class="bi bi-check"></i>';
  } else {
    mailItem.classList.remove("selected");
    checkbox.classList.remove("checked");
    checkbox.innerHTML = "";
  }
}

// Select all emails
function selectAll() {
  const allCheckboxes = document.querySelectorAll(".mail-checkbox");
  const allMailItems = document.querySelectorAll(".mail-item");

  if (selectedEmails.size === filteredEmails.length) {
    // Deselect all
    selectedEmails.clear();
    allCheckboxes.forEach((cb) => {
      cb.classList.remove("checked");
      cb.innerHTML = "";
    });
    allMailItems.forEach((item) => item.classList.remove("selected"));
  } else {
    // Select all
    filteredEmails.forEach((email) => selectedEmails.add(email.id));
    allCheckboxes.forEach((cb) => {
      cb.classList.add("checked");
      cb.innerHTML = '<i class="bi bi-check"></i>';
    });
    allMailItems.forEach((item) => item.classList.add("selected"));
  }
}

// Toggle star
function toggleStar(emailId) {
  const email = emails.find((e) => e.id === emailId);
  if (email) {
    email.starred = !email.starred;
    loadEmails();
  }
}

// View email
function viewEmail(emailId) {
  const email = emails.find((e) => e.id === emailId);
  if (!email) return;

  currentEmailId = emailId;

  // Mark as read
  email.unread = false;

  // Update UI
  mailListView.style.display = "none";
  emailView.style.display = "flex";

  // Build email view
  const attachmentsHtml = email.attachmentsList
    ? `
            <div class="email-attachments">
                <div class="attachments-title">
                    <i class="bi bi-paperclip"></i> Attachments (${
                      email.attachmentsList.length
                    })
                </div>
                <div class="attachments-list">
                    ${email.attachmentsList
                      .map(
                        (attachment) => `
                        <div class="attachment-item">
                            <div class="attachment-icon">
                                <i class="bi bi-file-earmark-${
                                  attachment.type === "pdf"
                                    ? "pdf"
                                    : attachment.type === "excel"
                                    ? "excel"
                                    : "text"
                                }"></i>
                            </div>
                            <div class="attachment-info">
                                <div class="attachment-name">${
                                  attachment.name
                                }</div>
                                <div class="attachment-size">${
                                  attachment.size
                                }</div>
                            </div>
                            <div class="attachment-download" onclick="downloadAttachment('${
                              attachment.name
                            }')">
                                <i class="bi bi-download"></i>
                            </div>
                        </div>
                    `
                      )
                      .join("")}
                </div>
            </div>
        `
    : "";

  emailView.innerHTML = `
            <div class="email-header">
                <div class="email-toolbar">
                    <button class="btn-outline" onclick="backToList()">
                        <i class="bi bi-arrow-left"></i> Back
                    </button>
                    <div class="action-buttons">
                        <button class="action-btn" onclick="toggleStar(${emailId})" title="${
    email.starred ? "Unstar" : "Star"
  }">
                            <i class="bi bi-star${
                              email.starred ? "-fill" : ""
                            }"></i>
                        </button>
                        <button class="action-btn" onclick="deleteEmail(${emailId})" title="Delete">
                            <i class="bi bi-trash"></i>
                        </button>
                        <!-- Action Button with Dropdown -->
                        <div class="email-actions-dropdown" id="emailActionsDropdown">
                            <button class="action-btn" onclick="toggleActionsDropdown()" title="More actions">
                                <i class="bi bi-three-dots"></i>
                            </button>
                            <div class="dropdown-dialog" id="actionsDropdown">
                                <a class="dropdown-item" href="#" onclick="replyToEmail()">
                                    <i class="bi bi-reply"></i>
                                    <span class="label">Reply</span>
                                </a>
                                <a class="dropdown-item" href="#" onclick="replyAllToEmail()">
                                    <i class="bi bi-reply-all"></i>
                                    <span class="label">Reply All</span>
                                </a>
                                <a class="dropdown-item" href="#" onclick="forwardEmail()">
                                    <i class="bi bi-share"></i>
                                    <span class="label">Forward</span>
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" onclick="printEmail(${emailId})">
                                    <i class="bi bi-printer"></i>
                                    <span class="label">Print</span>
                                </a>
                                <a class="dropdown-item" href="#" onclick="markAsUnread(${emailId})">
                                    <i class="bi bi-envelope"></i>
                                    <span class="label">Mark as Unread</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="email-subject">${email.subject}</div>
                
                <div class="email-info">
                    <div class="sender-info">
                        <div class="sender-avatar-lg">${
                          email.sender.avatar
                        }</div>
                        <div class="sender-details">
                            <div class="sender-name-lg">${
                              email.sender.name
                            }</div>
                            <div class="sender-email">${
                              email.sender.email
                            }</div>
                        </div>
                    </div>
                    <div class="email-meta">
                        <div class="email-date">${
                          email.date === "Today" ? "Today" : email.date
                        } at ${email.time}</div>
                        ${
                          email.labels && email.labels.length > 0
                            ? `
                            <div class="email-labels">
                                ${email.labels
                                  .map(
                                    (label) => `
                                    <span class="mail-label" style="background: ${getLabelColor(
                                      label
                                    )}; color: white;">${label}</span>
                                `
                                  )
                                  .join("")}
                            </div>
                        `
                            : ""
                        }
                    </div>
                </div>
            </div>
            
            <div class="email-body">
                <div class="email-content">
                    ${email.body}
                    ${attachmentsHtml}
                </div>
            </div>
            
            </div>
        `;

  // Initialize dropdown references
  actionsDropdown = document.getElementById("actionsDropdown");
  actionsDropdownBtn = document.querySelector(
    ".email-actions-dropdown .icon-btn"
  );

  // Reload mail list to update unread status
  loadEmails();
}

// Toggle actions dropdown
function toggleActionsDropdown() {
  if (actionsDropdown) {
    actionsDropdown.classList.toggle("show");
  }
}

// Close actions dropdown
function closeActionsDropdown() {
  if (actionsDropdown) {
    actionsDropdown.classList.remove("show");
  }
}

// Back to list view
function backToList() {
  mailListView.style.display = "block";
  emailView.style.display = "none";
  closeActionsDropdown();
}

// Compose email
function composeEmail() {
  composeModal.classList.add("active");
  closeActionsDropdown();
}

// Close compose modal
function closeCompose() {
  composeModal.classList.remove("active");
}

// Reply to email
function replyToEmail() {
  const email = emails.find((e) => e.id === currentEmailId);
  if (email) {
    document.getElementById("composeTo").value = email.sender.email;
    document.getElementById("composeCc").value = "";
    document.getElementById("composeBcc").value = "";
    document.getElementById("composeSubject").value = `Re: ${email.subject}`;
    document.getElementById(
      "composeBody"
    ).value = `\n\nOn ${email.date} at ${email.time}, ${email.sender.name} wrote:\n> ${email.preview}`;
    composeModal.classList.add("active");
    closeActionsDropdown();
  }
}

// Reply all to email
function replyAllToEmail() {
  const email = emails.find((e) => e.id === currentEmailId);
  if (email) {
    // Combine sender and CC recipients
    const allRecipients = [email.sender.email];
    if (email.recipients && email.recipients.cc) {
      allRecipients.push(...email.recipients.cc);
    }

    document.getElementById("composeTo").value = allRecipients.join(", ");
    document.getElementById("composeCc").value = "";
    document.getElementById("composeBcc").value = "";
    document.getElementById("composeSubject").value = `Re: ${email.subject}`;
    document.getElementById(
      "composeBody"
    ).value = `\n\nOn ${email.date} at ${email.time}, ${email.sender.name} wrote:\n> ${email.preview}`;
    composeModal.classList.add("active");
    closeActionsDropdown();
  }
}

// Forward email
function forwardEmail() {
  const email = emails.find((e) => e.id === currentEmailId);
  if (email) {
    document.getElementById("composeTo").value = "";
    document.getElementById("composeCc").value = "";
    document.getElementById("composeBcc").value = "";
    document.getElementById("composeSubject").value = `Fwd: ${email.subject}`;
    document.getElementById(
      "composeBody"
    ).value = `\n\n---------- Forwarded message ----------\nFrom: ${email.sender.name}\nDate: ${email.date} at ${email.time}\nSubject: ${email.subject}\n\n${email.body}`;
    composeModal.classList.add("active");
    closeActionsDropdown();
  }
}

// Send email
function sendEmail() {
  const to = document.getElementById("composeTo").value;
  const subject = document.getElementById("composeSubject").value;
  const body = document.getElementById("composeBody").value;

  if (!to || !subject || !body) {
    return;
  }

  // Simulate sending

  setTimeout(() => {
    closeCompose();

    // Clear form
    document.getElementById("composeTo").value = "";
    document.getElementById("composeCc").value = "";
    document.getElementById("composeBcc").value = "";
    document.getElementById("composeSubject").value = "";
    document.getElementById("composeBody").value = "";
  }, 1500);
}

// Save draft
function saveDraft() {
  closeCompose();
}

// Send reply
function sendReply() {
  const replyText = document.getElementById("replyTextarea").value;
  if (!replyText.trim()) {
    return;
  }
  document.getElementById("replyTextarea").value = "";
}

// Delete email
function deleteEmail(emailId) {
  if (confirm("Are you sure you want to delete this email?")) {
    const email = emails.find((e) => e.id === emailId);
    if (email) {
      email.folder = "trash";
      backToList();
      loadEmails();
    }
  }
  closeActionsDropdown();
}

// Mark as unread
function markAsUnread(emailId) {
  const email = emails.find((e) => e.id === emailId);
  if (email) {
    email.unread = true;

    loadEmails();
  }
  closeActionsDropdown();
}

// Archive selected
function archiveSelected() {
  if (selectedEmails.size === 0) {
    return;
  }

  selectedEmails.forEach((id) => {
    const email = emails.find((e) => e.id === id);
    if (email) {
      email.folder = "archive";
    }
  });

  selectedEmails.clear();
  loadEmails();
}

// Delete selected
function deleteSelected() {
  if (selectedEmails.size === 0) {
    return;
  }

  if (
    confirm(
      `Are you sure you want to move ${selectedEmails.size} email(s) to trash?`
    )
  ) {
    selectedEmails.forEach((id) => {
      const email = emails.find((e) => e.id === id);
      if (email) {
        email.folder = "trash";
      }
    });

    selectedEmails.clear();
    loadEmails();
  }
}

// Toggle sidebar
function toggleSidebar() {
  mailSidebar.classList.toggle("active");
}

// Change folder
function setupFolderNavigation() {
  document.querySelectorAll(".folder-link").forEach((link) => {
    link.addEventListener("click", function (e) {
      e.preventDefault();

      // Update active folder
      document
        .querySelectorAll(".folder-link")
        .forEach((l) => l.classList.remove("active"));
      this.classList.add("active");

      // Change folder
      currentFolder = this.getAttribute("data-folder");
      loadEmails();

      // Close sidebar on mobile
      if (window.innerWidth < 1200) {
        mailSidebar.classList.remove("active");
      }
    });
  });
}

// Setup label filtering
function setupLabelFiltering() {
  document.querySelectorAll(".label-item").forEach((item) => {
    item.addEventListener("click", function () {
      const label = this.getAttribute("data-label");
      MailsearchInput.value = label;
      loadEmails();
    });
  });
}

// Initialize
document.addEventListener("DOMContentLoaded", function () {
  // Load initial emails
  loadEmails();
  setupFolderNavigation();
  // Search functionality
  if(MailsearchInput){
    MailsearchInput.addEventListener("input", loadEmails);
  }
});

// Close dropdowns on outside click
document.addEventListener("click", (e) => {
  if ( composeModal &&
    !composeModal.contains(e.target) &&
    e.target !== document.querySelector(".compose-btn")
  ) {
    closeCompose();
  }
  if (
    mailSidebar && mailSidebar.classList.contains("active") &&
    !mailSidebar.contains(e.target) &&
    e.target !== document.querySelector('[onclick="toggleSidebar()"]')
  ) {
    mailSidebar.classList.remove("active");
  }
});

// Close on Escape key
document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    closeAll();
    sidebar?.classList.remove("show");
    closeCompose();
    if (emailView.style.display === "flex") {
      backToList();
    }
  }
});
