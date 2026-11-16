/**
 * @typedef {object} PathItem
 * @property {"Dir"|"SymlinkDir"|"File"|"SymlinkFile"} path_type
 * @property {string} name
 * @property {number} mtime
 * @property {number} size
 */

/**
 * @typedef {object} DATA
 * @property {string} href
 * @property {string} uri_prefix
 * @property {"Index" | "Edit" | "View"} kind
 * @property {PathItem[]} paths
 * @property {boolean} allow_upload
 * @property {boolean} allow_delete
 * @property {boolean} allow_search
 * @property {boolean} allow_archive
 * @property {boolean} auth
 * @property {string} user
 * @property {boolean} dir_exists
 * @property {string} editable
 */

const DUFS_MAX_UPLOADINGS = 1;

/**
 * Runtime state shared by the page controllers.
 * Keeping this in one object makes the data flow explicit without adding a
 * framework or changing the Dufs template contract.
 */
const APP = {
  data: null,
  emptyNote: "",
  dom: {},
};

const UPLOAD_STATE = {
  nextId: 0,
  running: 0,
  authenticated: false,
  queue: [],
};

/**
 * @type {PARAMS}
 * @typedef {object} PARAMS
 * @property {string} q
 * @property {string} sort
 * @property {string} order
 */
const PARAMS = Object.fromEntries(new URLSearchParams(window.location.search).entries());

const IFRAME_FORMATS = [
  ".pdf",
  ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg",
  ".mp4", ".mov", ".avi", ".wmv", ".flv", ".webm",
  ".mp3", ".ogg", ".wav", ".m4a",
];

const MAX_SUBPATHS_COUNT = 1000;

const ICONS = {
  dir: `<svg height="16" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M13 4H7V3c0-.66-.31-1-1-1H1c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1V5c0-.55-.45-1-1-1zM6 4H1V3h5v1z"></path></svg>`,
  symlinkFile: `<svg height="16" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M8.5 1H1c-.55 0-1 .45-1 1v12c0 .55.45 1 1 1h10c.55 0 1-.45 1-1V4.5L8.5 1zM11 14H1V2h7l3 3v9zM6 4.5l4 3-4 3v-2c-.98-.02-1.84.22-2.55.7-.71.48-1.19 1.25-1.45 2.3.02-1.64.39-2.88 1.13-3.73.73-.84 1.69-1.27 2.88-1.27v-2H6z"></path></svg>`,
  symlinkDir: `<svg height="16" viewBox="0 0 14 16" width="14"><path fill-rule="evenodd" d="M13 4H7V3c0-.66-.31-1-1-1H1c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1V5c0-.55-.45-1-1-1zM1 3h5v1H1V3zm6 9v-2c-.98-.02-1.84.22-2.55.7-.71.48-1.19 1.25-1.45 2.3.02-1.64.39-2.88 1.13-3.73C4.86 8.43 5.82 8 7.01 8V6l4 3-4 3H7z"></path></svg>`,
  file: `<svg height="16" viewBox="0 0 12 16" width="12"><path fill-rule="evenodd" d="M6 5H2V4h4v1zM2 8h7V7H2v1zm0 2h7V9H2v1zm0 2h7v-1H2v1zm10-7.5V14c0 .55-.45 1-1 1H1c-.55 0-1-.45-1-1V2c0-.55.45-1 1-1h7.5L12 4.5zM11 5L8 2H1v12h10V5z"></path></svg>`,
  download: `<svg width="16" height="16" viewBox="0 0 16 16"><path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/><path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/></svg>`,
  move: `<svg width="16" height="16" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/></svg>`,
  edit: `<svg width="16" height="16" viewBox="0 0 16 16"><path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/></svg>`,
  delete: `<svg width="16" height="16" viewBox="0 0 16 16"><path d="M6.854 7.146a.5.5 0 1 0-.708.708L7.293 9l-1.147 1.146a.5.5 0 0 0 .708.708L8 9.707l1.146 1.147a.5.5 0 0 0 .708-.708L8.707 9l1.147-1.146a.5.5 0 0 0-.708-.708L8 8.293 6.854 7.146z"/><path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/></svg>`,
  view: `<svg width="16" height="16" viewBox="0 0 16 16"><path d="M4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zm0 1h8a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1"/></svg>`,
}

/**
 * @type Map<string, Uploader>
 */
const failUploaders = new Map();

// manage unload event to prevent leaving with uploads in progress
const beforeUnloadHandler = (event) => {
  if (UPLOAD_STATE.queue.length > 0 || UPLOAD_STATE.running > 0) {
    event.preventDefault();
    event.returnValue = '';
    return ''; // for some browsers
  }
};

// Produce table when window loads
window.addEventListener("DOMContentLoaded", async () => {
  const $indexData = document.getElementById('index-data');
  if (!$indexData) {
    alert("No data");
    return;
  }

  // Dufs writes the base64 payload into the template's HTML content.
  // Use innerHTML here to match the original Dufs asset contract.
  APP.data = parseIndexData($indexData.innerHTML);
  APP.emptyNote = PARAMS.q ? 'No results' : APP.data.dir_exists ? 'Empty folder' : 'Folder will be created when a file is uploaded';

  await ready();
});

async function ready() {
  APP.dom = {
    pathsTable: document.querySelector(".paths-table"),
    pathsTableHead: document.querySelector(".paths-table thead"),
    pathsTableBody: document.querySelector(".paths-table tbody"),
    uploadersTable: document.querySelector(".uploaders-table"),
    emptyFolder: document.querySelector(".empty-folder"),
    editor: document.querySelector(".editor"),
    loginButton: document.querySelector(".login-btn"),
    logoutButton: document.querySelector(".logout-btn"),
    userName: document.querySelector(".user-name"),
  };

  window.addEventListener('beforeunload', beforeUnloadHandler);

  addBreadcrumb(APP.data.href, APP.data.uri_prefix);

  if (APP.data.kind === "Index") {
    document.title = `Index of ${APP.data.href} - Dufs`;
    document.querySelector(".index-page").classList.remove("hidden");

    setupIndexPage();
  } else if (APP.data.kind === "Edit") {
    document.title = `Edit ${APP.data.href} - Dufs`;
    document.querySelector(".editor-page").classList.remove("hidden");

    await setupEditorPage();
  } else if (APP.data.kind === "View") {
    document.title = `View ${APP.data.href} - Dufs`;
    document.querySelector(".editor-page").classList.remove("hidden");

    await setupEditorPage();
  }
}

class Uploader {
  /**
   *
   * @param {File} file
   * @param {string[]} pathParts
   */
  constructor(file, pathParts) {
    /**
     * @type Element
     */
    this.$uploadStatus = null
    this.uploaded = 0;
    this.uploadOffset = 0;
    this.lastUptime = 0;
    this.state = "idle";
    this.resumeOnStart = false;
    this.pathParts = pathParts.filter(part => part.length > 0);
    this.name = [...this.pathParts, file.name].join("/");
    this.idx = UPLOAD_STATE.nextId++;
    this.file = file;
    this.url = newUrl(this.name);
  }

  upload() {
    const { idx, name, url } = this;
    const encodedName = encodedStr(name);
    APP.dom.uploadersTable.insertAdjacentHTML("beforeend", `
  <tr id="upload${idx}" class="uploader">
    <td class="path cell-icon">
      ${getPathSvg()}
    </td>
    <td class="path cell-name">
      <a href="${url}">${encodedName}</a>
    </td>
    <td class="cell-status upload-status" id="uploadStatus${idx}"></td>
  </tr>`);
    APP.dom.uploadersTable.classList.remove("hidden");
    APP.dom.emptyFolder.classList.add("hidden");
    this.$uploadStatus = document.getElementById(`uploadStatus${idx}`);
    this.$uploadStatus.innerHTML = '-';
    this.$uploadStatus.addEventListener("click", e => {
      const nodeId = e.target.id;
      const matches = /^retry(\d+)$/.exec(nodeId);
      if (matches) {
        const id = parseInt(matches[1]);
        let uploader = failUploaders.get(id);
        if (uploader) uploader.retry();
      }
    });
    this.state = "queued";
    UPLOAD_STATE.queue.push(this);
    runUploadQueue();
  }

  ajax() {
    const { url } = this;

    this.uploaded = 0;
    this.lastUptime = Date.now();

    const ajax = new XMLHttpRequest();
    ajax.upload.addEventListener("progress", e => this.progress(e), false);
    ajax.addEventListener("readystatechange", () => {
      if (ajax.readyState === 4) {
        if (ajax.status >= 200 && ajax.status < 300) {
          this.complete();
        } else {
          if (ajax.status != 0) {
            this.fail(`${ajax.status} ${ajax.statusText}`);
          }
        }
      }
    })
    ajax.addEventListener("error", () => this.fail(), false);
    ajax.addEventListener("abort", () => this.fail(), false);
    if (this.uploadOffset > 0) {
      ajax.open("PATCH", url);
      ajax.setRequestHeader("X-Update-Range", "append");
      ajax.send(this.file.slice(this.uploadOffset));
    } else {
      ajax.open("PUT", url);
      ajax.send(this.file);
      // setTimeout(() => ajax.abort(), 3000);
    }
  }

  retry() {
    if (this.state !== "failed") return;
    this.state = "queued";
    this.resumeOnStart = true;
    failUploaders.delete(this.idx);
    this.$uploadStatus.textContent = '-';
    UPLOAD_STATE.queue.push(this);
    runUploadQueue();
  }

  async prepareResume() {
    const { url } = this;
    let res = await fetch(url, {
      method: "HEAD",
    });
    let uploadOffset = 0;
    if (res.status == 200) {
      let value = res.headers.get("content-length");
      uploadOffset = parseInt(value) || 0;
    }
    this.uploadOffset = uploadOffset;
    if (res.status !== 200 && res.status !== 404) {
      throw new Error(`Cannot resume upload (${res.status} ${res.statusText})`);
    }
    if (!Number.isSafeInteger(uploadOffset) || uploadOffset < 0 || uploadOffset > this.file.size) {
      throw new Error("Cannot resume upload: invalid remote file size");
    }
  }

  progress(event) {
    const now = Date.now();
    const elapsed = now - this.lastUptime;
    if (elapsed < 300) return; // throttle update for safari
    const speed = (event.loaded - this.uploaded) / elapsed * 1000;
    const [speedValue, speedUnit] = formatFileSize(speed);
    const speedText = `${speedValue} ${speedUnit}/s`;
    const progress = formatPercent(((event.loaded + this.uploadOffset) / this.file.size) * 100);
    const duration = formatDuration((event.total - event.loaded) / speed);
    this.$uploadStatus.innerHTML = `<span style="width: 80px;">${speedText}</span><span style="margin-left: 5px;">${progress} ${duration}</span>`;
    this.uploaded = event.loaded;
    this.lastUptime = now;
  }

  complete() {
    if (this.state !== "running") return;
    this.state = "complete";
    const $uploadStatusNew = this.$uploadStatus.cloneNode(true);
    $uploadStatusNew.innerHTML = `✓`;
    this.$uploadStatus.parentNode.replaceChild($uploadStatusNew, this.$uploadStatus);
    this.$uploadStatus = null;
    failUploaders.delete(this.idx);
    UPLOAD_STATE.running--;
    runUploadQueue();
  }

  fail(reason = "") {
    if (this.state !== "running") return;
    this.state = "failed";
    this.$uploadStatus.innerHTML = `<span style="width: 20px;" title="${reason}">✗</span><span class="retry-btn" id="retry${this.idx}" title="Retry">↻</span>`;
    failUploaders.set(this.idx, this);
    UPLOAD_STATE.running--;
    runUploadQueue();
  }
}

const uploadDirectories = new Map();

async function ensureUploadDirectories(pathParts) {
  let directoryPath = "";
  for (const pathPart of pathParts) {
    directoryPath = directoryPath ? `${directoryPath}/${pathPart}` : pathPart;
    const key = directoryPath;
    if (!uploadDirectories.has(key)) {
      const promise = fetch(newUrl(directoryPath), {
        method: "MKCOL",
      }).then(async res => {
        // Dufs reports an existing directory as Method Not Allowed.
        if (!(res.status >= 200 && res.status < 300) && res.status !== 405) {
          throw new Error(await res.text() || `Cannot create directory (${res.status})`);
        }
      }).catch(err => {
        uploadDirectories.delete(key);
        throw err;
      });
      uploadDirectories.set(key, promise);
    }
    await uploadDirectories.get(key);
  }
}


async function runUploadQueue() {
  if (UPLOAD_STATE.running >= DUFS_MAX_UPLOADINGS) return;
  if (UPLOAD_STATE.queue.length == 0) return;
  UPLOAD_STATE.running++;
  let uploader = UPLOAD_STATE.queue.shift();
  uploader.state = "running";
  if (!UPLOAD_STATE.authenticated) {
    UPLOAD_STATE.authenticated = true;
    try {
      await checkAuth();
    } catch {
      UPLOAD_STATE.authenticated = false;
    }
  }
  try {
    if (uploader.resumeOnStart) {
      await uploader.prepareResume();
      uploader.resumeOnStart = false;
    }
    await ensureUploadDirectories(uploader.pathParts);
    uploader.ajax();
  } catch (err) {
    uploader.fail(err.message);
  }
}

function enqueueUpload(file, pathParts = []) {
  new Uploader(file, pathParts).upload();
}

/**
 * Add breadcrumb
 * @param {string} href
 * @param {string} uri_prefix
 */
function addBreadcrumb(href, uri_prefix) {
  const $breadcrumb = document.querySelector(".breadcrumb");
  let parts = [];
  if (href === "/") {
    parts = [""];
  } else {
    parts = href.split("/");
  }
  const len = parts.length;
  let path = uri_prefix;
  for (let i = 0; i < len; i++) {
    const name = parts[i];
    if (i > 0) {
      if (!path.endsWith("/")) {
        path += "/";
      }
      path += encodeURIComponent(name);
    }
    const encodedName = encodedStr(name);
    if (i === 0) {
      $breadcrumb.insertAdjacentHTML("beforeend", `<a href="${path}" title="Root"><svg width="16" height="16" viewBox="0 0 16 16"><path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/></svg></a>`);
    } else if (i === len - 1) {
      $breadcrumb.insertAdjacentHTML("beforeend", `<b>${encodedName}</b>`);
    } else {
      $breadcrumb.insertAdjacentHTML("beforeend", `<a href="${path}">${encodedName}</a>`);
    }
    if (i !== len - 1) {
      $breadcrumb.insertAdjacentHTML("beforeend", `<span class="separator">/</span>`);
    }
  }
}

function setupIndexPage() {
  setupDetailsToggle();
  setupViewToggle();

  if (APP.data.allow_archive) {
    const $download = document.querySelector(".download");
    $download.href = baseUrl() + "?zip";
    $download.title = "Download folder as a .zip file";
    $download.classList.add("dlwt");
    $download.classList.remove("hidden");
  }

  if (APP.data.allow_upload) {
    setupDropzone();
    setupUploadFile();
    setupNewFolder();
    setupNewFile();
  }

  if (APP.data.auth) {
    setupAuth();
  }

  if (APP.data.allow_search) {
    setupSearch();
  }

  renderPathsTableHead();
  renderPathsTableBody();
  setupPathActions();

  if (APP.data.user) {
    setupDownloadWithToken();
  }
}

function setupViewToggle() {
  const $toggle = document.querySelector(".view-toggle");
  if (!$toggle) return;

  setupPersistentToggle($toggle, {
    key: "dufs-tile-view",
    defaultValue: false,
    apply: visible => {
      document.documentElement.classList.toggle("tiles-view", visible);
      $toggle.textContent = visible ? "Tiles" : "List";
      $toggle.title = visible ? "Switch to list view" : "Switch to tile view";
    },
  });
}

function setupDetailsToggle() {
  const $toggle = document.querySelector(".details-toggle");
  if (!$toggle) return;

  setupPersistentToggle($toggle, {
    key: "dufs-show-details",
    defaultValue: !window.matchMedia("(max-width: 767px)").matches,
    apply: visible => {
      document.documentElement.classList.toggle("show-details", visible);
      document.documentElement.classList.toggle("hide-details", !visible);
      $toggle.title = visible ? "Hide modified date and size" : "Show modified date and size";
    },
  });
}

function setupPersistentToggle($toggle, { key, defaultValue, apply }) {
  let visible = defaultValue;
  try {
    const storedValue = localStorage.getItem(key);
    if (storedValue === "true" || storedValue === "false") {
      visible = storedValue === "true";
    }
  } catch { }

  const setVisible = nextValue => {
    visible = nextValue;
    $toggle.setAttribute("aria-pressed", String(visible));
    apply(visible);
    try {
      localStorage.setItem(key, String(visible));
    } catch { }
  };

  setVisible(visible);
  $toggle.addEventListener("click", () => setVisible(!visible));
}

/**
 * Render path table thead
 */
function renderPathsTableHead() {
  const headerItems = [
    {
      name: "name",
      props: `colspan="2"`,
      text: "Name",
    },
    {
      name: "mtime",
      props: ``,
      text: "Last Modified",
    },
    {
      name: "size",
      props: ``,
      text: "Size",
    }
  ];
  APP.dom.pathsTableHead.insertAdjacentHTML("beforeend", `
    <tr>
      ${headerItems.map(item => {
    let svg = `<svg width="12" height="12" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M11.5 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L11 2.707V14.5a.5.5 0 0 0 .5.5zm-7-14a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L4 13.293V1.5a.5.5 0 0 1 .5-.5z"/></svg>`;
    let order = "desc";
    if (PARAMS.sort === item.name) {
      if (PARAMS.order === "desc") {
        order = "asc";
        svg = `<svg width="12" height="12" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 1a.5.5 0 0 1 .5.5v11.793l3.146-3.147a.5.5 0 0 1 .708.708l-4 4a.5.5 0 0 1-.708 0l-4-4a.5.5 0 0 1 .708-.708L7.5 13.293V1.5A.5.5 0 0 1 8 1z"/></svg>`
      } else {
        svg = `<svg width="12" height="12" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M8 15a.5.5 0 0 0 .5-.5V2.707l3.146 3.147a.5.5 0 0 0 .708-.708l-4-4a.5.5 0 0 0-.708 0l-4 4a.5.5 0 1 0 .708.708L7.5 2.707V14.5a.5.5 0 0 0 .5.5z"/></svg>`
      }
    }
    const qs = new URLSearchParams({ ...PARAMS, order, sort: item.name }).toString();
    const icon = `<span>${svg}</span>`
    return `<th class="cell-${item.name}" ${item.props}><a href="?${qs}">${item.text}${icon}</a></th>`
  }).join("\n")}
      <th class="cell-actions">Actions</th>
    </tr>
  `);
}

/**
 * Render path table tbody
 */
function renderPathsTableBody() {
  if (APP.data.paths && APP.data.paths.length > 0) {
    const len = APP.data.paths.length;
    if (len > 0) {
      APP.dom.pathsTable.classList.remove("hidden");
    }
    for (let i = 0; i < len; i++) {
      addPath(APP.data.paths[i], i);
    }
  } else {
    APP.dom.emptyFolder.textContent = APP.emptyNote;
    APP.dom.emptyFolder.classList.remove("hidden");
  }
}

/**
 * Add pathitem
 * @param {PathItem} file
 * @param {number} index
 */
function addPath(file, index) {
  const encodedName = encodedStr(file.name);
  const isDir = file.path_type.endsWith("Dir");
  const url = newUrl(file.name) + (isDir ? "/" : "");
  const canMove = APP.data.allow_delete && APP.data.allow_upload;
  const canEdit = canMove && !isDir;
  const download = isDir
    ? (APP.data.allow_archive ? `<div class="action-btn"><a class="dlwt" href="${url}?zip" title="Download folder as a .zip file" download>${ICONS.download}</a></div>` : "")
    : `<div class="action-btn"><a class="dlwt" href="${url}" title="Download file" download>${ICONS.download}</a></div>`;
  const view = !canEdit && !isDir ? `<a class="action-btn" title="View file" target="_blank" href="${url}?view">${ICONS.view}</a>` : "";
  const move = canMove ? `<button type="button" class="action-btn" data-path-action="move" data-path-index="${index}" id="moveBtn${index}" title="Move & Rename">${ICONS.move}</button>` : "";
  const remove = APP.data.allow_delete ? `<button type="button" class="action-btn" data-path-action="delete" data-path-index="${index}" id="deleteBtn${index}" title="Delete">${ICONS.delete}</button>` : "";
  const edit = canEdit ? `<a class="action-btn" title="Edit file" target="_blank" href="${url}?edit">${ICONS.edit}</a>` : "";
  const actionCell = `
  <td class="cell-actions">
    ${download}${view}${move}${remove}${edit}
  </td>`;

  const sizeDisplay = isDir ? formatDirSize(file.size) : formatFileSize(file.size).join(" ");

  APP.dom.pathsTableBody.insertAdjacentHTML("beforeend", `
<tr id="addPath${index}">
  <td class="path cell-icon">
    ${getPathSvg(file.path_type)}
  </td>
  <td class="path cell-name">
    <a href="${url}" ${isDir ? "" : `target="_blank"`}>${encodedName}</a>
  </td>
  <td class="cell-mtime">${formatMtime(file.mtime)}</td>
  <td class="cell-size">${sizeDisplay}</td>
  ${actionCell}
</tr>`);
}

function setupPathActions() {
  APP.dom.pathsTableBody.addEventListener("click", event => {
    const action = event.target.closest("[data-path-action]");
    if (!action) return;

    const index = Number(action.dataset.pathIndex);
    if (action.dataset.pathAction === "move") {
      movePath(index);
    } else if (action.dataset.pathAction === "delete") {
      deletePath(index);
    }
  });
}

function setupDropzone() {
  ["drag", "dragstart", "dragend", "dragover", "dragenter", "dragleave", "drop"].forEach(name => {
    document.addEventListener(name, e => {
      e.preventDefault();
      e.stopPropagation();
    });
  });
  document.addEventListener("drop", async e => {
    if (!e.dataTransfer.items[0].webkitGetAsEntry) {
      const files = Array.from(e.dataTransfer.files).filter(v => v.size > 0);
      for (const file of files) {
        enqueueUpload(file);
      }
    } else {
      const entries = [];
      const len = e.dataTransfer.items.length;
      for (let i = 0; i < len; i++) {
        entries.push(e.dataTransfer.items[i].webkitGetAsEntry());
      }
      addFileEntries(entries).catch(err => alert(`Cannot read folder, ${err.message}`));
    }
  });
}

function setupAuth() {
  if (APP.data.user) {
    APP.dom.logoutButton.classList.remove("hidden");
    APP.dom.logoutButton.addEventListener("click", logout);
    APP.dom.userName.textContent = APP.data.user;
  } else {
    APP.dom.loginButton.classList.remove("hidden");
    APP.dom.loginButton.addEventListener("click", async () => {
      try {
        await checkAuth("login");
      } catch { }
      location.reload();
    });
  }
}

function setupDownloadWithToken() {
  document.querySelectorAll("a.dlwt").forEach(link => {
    link.addEventListener("click", async e => {
      e.preventDefault();
      try {
        const link = e.currentTarget || e.target;
        const originalHref = link.getAttribute("href");
        const tokengenUrl = new URL(originalHref);
        tokengenUrl.searchParams.set("tokengen", "");
        const res = await requestOk(tokengenUrl);
        const token = await res.text();
        const downloadUrl = new URL(originalHref);
        downloadUrl.searchParams.set("token", token);
        const tempA = document.createElement("a");
        tempA.href = downloadUrl.toString();
        tempA.download = "";
        document.body.appendChild(tempA);
        tempA.click();
        document.body.removeChild(tempA);
      } catch (err) {
        alert(`Failed to download, ${err.message}`);
      }
    });
  });
}

function setupSearch() {
  const $searchbar = document.querySelector(".searchbar");
  $searchbar.classList.remove("hidden");
  $searchbar.addEventListener("submit", event => {
    event.preventDefault();
    const formData = new FormData($searchbar);
    const q = formData.get("q");
    let href = baseUrl();
    if (q) {
      href += "?q=" + q;
    }
    location.href = href;
  });
  if (PARAMS.q) {
    document.getElementById('search').value = PARAMS.q;
  }
}

function setupUploadFile() {
  document.querySelector(".upload-file").classList.remove("hidden");
  document.querySelector(".upload-folder").classList.remove("hidden");
  document.getElementById("file").addEventListener("change", e => queueSelectedFiles(e.target.files, false, e.target));
  document.getElementById("folder").addEventListener("change", e => queueSelectedFiles(e.target.files, true, e.target));
}

function queueSelectedFiles(files, preservePaths, input) {
  for (const file of files) {
    const relativePath = preservePaths ? (file.webkitRelativePath || file.name) : file.name;
    const pathParts = relativePath.split("/").slice(0, -1);
    enqueueUpload(file, pathParts);
  }
  // Allow selecting the same file or folder again after a failed upload.
  input.value = "";
}

function setupNewFolder() {
  const $newFolder = document.querySelector(".new-folder");
  $newFolder.classList.remove("hidden");
  $newFolder.addEventListener("click", () => {
    const name = prompt("Enter folder name");
    if (name) createFolder(name);
  });
}

function setupNewFile() {
  const $newFile = document.querySelector(".new-file");
  $newFile.classList.remove("hidden");
  $newFile.addEventListener("click", () => {
    const name = prompt("Enter file name");
    if (name) createFile(name);
  });
}

async function setupEditorPage() {
  const url = baseUrl();

  const $download = document.querySelector(".download");
  $download.classList.remove("hidden");
  $download.href = url;

  if (APP.data.kind == "Edit") {
    const $moveFile = document.querySelector(".move-file");
    $moveFile.classList.remove("hidden");
    $moveFile.addEventListener("click", async () => {
      const query = location.href.slice(url.length);
      const newFileUrl = await doMovePath(url);
      if (newFileUrl) {
        location.href = newFileUrl + query;
      }
    });

    const $deleteFile = document.querySelector(".delete-file");
    $deleteFile.classList.remove("hidden");
    $deleteFile.addEventListener("click", async () => {
      const url = baseUrl();
      const name = baseName(url);
      await doDeletePath(name, url, () => {
        location.href = location.href.split("/").slice(0, -1).join("/");
      });
    });

    if (APP.data.editable) {
      const $saveBtn = document.querySelector(".save-btn");
      $saveBtn.classList.remove("hidden");
      $saveBtn.addEventListener("click", saveChange);
    }
  } else if (APP.data.kind == "View") {
    APP.dom.editor.readonly = true;
  }

  if (!APP.data.editable) {
    const $notEditable = document.querySelector(".not-editable");
    const url = baseUrl();
    const ext = extName(baseName(url));
    if (IFRAME_FORMATS.find(v => v === ext)) {
      $notEditable.insertAdjacentHTML("afterend", `<iframe src="${url}" sandbox width="100%" height="${window.innerHeight - 100}px"></iframe>`);
    } else {
      $notEditable.classList.remove("hidden");
      $notEditable.textContent = "Cannot edit because file is too large or binary.";
    }
    return;
  }

  APP.dom.editor.classList.remove("hidden");
  try {
    const res = await requestOk(baseUrl());
    const encoding = getEncoding(res.headers.get("content-type"));
    if (encoding === "utf-8") {
      APP.dom.editor.value = await res.text();
    } else {
      const bytes = await res.arrayBuffer();
      const dataView = new DataView(bytes);
      const decoder = new TextDecoder(encoding);
      APP.dom.editor.value = decoder.decode(dataView);
    }
  } catch (err) {
    alert(`Failed to get file, ${err.message}`);
  }
}

/**
 * Delete path
 * @param {number} index
 * @returns
 */
async function deletePath(index) {
  const file = APP.data.paths[index];
  if (!file) return;
  await doDeletePath(file.name, newUrl(file.name), () => {
    document.getElementById(`addPath${index}`)?.remove();
    APP.data.paths[index] = null;
    if (!APP.data.paths.find(v => !!v)) {
      APP.dom.pathsTable.classList.add("hidden");
      APP.dom.emptyFolder.textContent = APP.emptyNote;
      APP.dom.emptyFolder.classList.remove("hidden");
    }
  });
}

async function doDeletePath(name, url, cb) {
  if (!confirm(`Delete \`${name}\`?`)) return;
  try {
    await checkAuth();
    await requestOk(url, {
      method: "DELETE",
    });
    cb();
  } catch (err) {
    alert(`Cannot delete \`${name}\`, ${err.message}`);
  }
}

/**
 * Move path
 * @param {number} index
 * @returns
 */
async function movePath(index) {
  const file = APP.data.paths[index];
  if (!file) return;
  const fileUrl = newUrl(file.name);
  const newFileUrl = await doMovePath(fileUrl);
  if (newFileUrl) {
    location.href = newFileUrl.split("/").slice(0, -1).join("/");
  }
}

async function doMovePath(fileUrl) {
  const fileUrlObj = new URL(fileUrl);

  const prefix = APP.data.uri_prefix.slice(0, -1);

  const filePath = decodeURIComponent(fileUrlObj.pathname.slice(prefix.length));

  let newPath = prompt("Enter new path", filePath);
  if (!newPath) return;
  if (!newPath.startsWith("/")) newPath = "/" + newPath;
  if (filePath === newPath) return;
  const newFileUrl = fileUrlObj.origin + prefix + newPath.split("/").map(encodeURIComponent).join("/");

  try {
    await checkAuth();
    const res1 = await fetch(newFileUrl, {
      method: "HEAD",
    });
    if (res1.status === 200) {
      if (!confirm("Override existing file?")) {
        return;
      }
    }
    await requestOk(fileUrl, {
      method: "MOVE",
      headers: {
        "Destination": newFileUrl,
      }
    });
    return newFileUrl;
  } catch (err) {
    alert(`Cannot move \`${filePath}\` to \`${newPath}\`, ${err.message}`);
  }
}


/**
 * Save editor change
 */
async function saveChange() {
  try {
    await requestOk(baseUrl(), {
      method: "PUT",
      body: APP.dom.editor.value,
    });
    location.reload();
  } catch (err) {
    alert(`Failed to save file, ${err.message}`);
  }
}

async function checkAuth(variant) {
  if (!APP.data.auth) return;
  const qs = variant ? `?${variant}` : "";
  const res = await requestOk(baseUrl() + qs, {
    method: "CHECKAUTH",
  });
  APP.dom.loginButton.classList.add("hidden");
  APP.dom.logoutButton.classList.remove("hidden");
  APP.dom.userName.textContent = await res.text();
}

function logout() {
  if (!APP.data.auth) return;
  const url = baseUrl();
  const xhr = new XMLHttpRequest();
  xhr.open("LOGOUT", url, true, APP.data.user);
  xhr.onload = () => {
    location.href = url;
  }
  xhr.send();
}

/**
 * Create a folder
 * @param {string} name
 */
async function createFolder(name) {
  const url = newUrl(name);
  try {
    await checkAuth();
    await requestOk(url, {
      method: "MKCOL",
    });
    location.href = url;
  } catch (err) {
    alert(`Cannot create folder \`${name}\`, ${err.message}`);
  }
}

async function createFile(name) {
  const url = newUrl(name);
  try {
    await checkAuth();
    await requestOk(url, {
      method: "PUT",
      body: "",
    });
    location.href = url + "?edit";
  } catch (err) {
    alert(`Cannot create file \`${name}\`, ${err.message}`);
  }
}

async function addFileEntries(entries, dirs = []) {
  await Promise.all(entries.map(entry => readFileEntry(entry, dirs)));
}

function readFileEntry(entry, dirs) {
  if (entry.isFile) {
    return new Promise((resolve, reject) => {
      entry.file(file => {
        enqueueUpload(file, dirs);
        resolve();
      }, reject);
    });
  }

  if (!entry.isDirectory) return Promise.resolve();

  const nextDirs = [...dirs, entry.name];
  const reader = entry.createReader();

  const readBatch = () => new Promise((resolve, reject) => {
    reader.readEntries(resolve, reject);
  }).then(async batch => {
    if (batch.length === 0) return;
    await addFileEntries(batch, nextDirs);
    return readBatch();
  });

  return readBatch();
}


function newUrl(name) {
  let url = baseUrl();
  if (!url.endsWith("/")) url += "/";
  url += name.split("/").map(encodeURIComponent).join("/");
  return url;
}

function baseUrl() {
  return location.href.split(/[?#]/)[0];
}

function baseName(url) {
  return decodeURIComponent(url.split("/").filter(v => v.length > 0).slice(-1)[0]);
}

function extName(filename) {
  const dotIndex = filename.lastIndexOf('.');

  if (dotIndex === -1 || dotIndex === 0 || dotIndex === filename.length - 1) {
    return '';
  }

  return filename.substring(dotIndex);
}

function getPathSvg(path_type) {
  switch (path_type) {
    case "Dir":
      return ICONS.dir;
    case "SymlinkFile":
      return ICONS.symlinkFile;
    case "SymlinkDir":
      return ICONS.symlinkDir;
    default:
      return ICONS.file;
  }
}

function formatMtime(mtime) {
  if (!mtime) return "";
  const date = new Date(mtime);
  const year = date.getFullYear();
  const month = padZero(date.getMonth() + 1, 2);
  const day = padZero(date.getDate(), 2);
  const hours = padZero(date.getHours(), 2);
  const minutes = padZero(date.getMinutes(), 2);
  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

function padZero(value, size) {
  return ("0".repeat(size) + value).slice(-1 * size);
}

function formatDirSize(size) {
  const unit = size === 1 ? "item" : "items";
  const num = size >= MAX_SUBPATHS_COUNT ? `>${MAX_SUBPATHS_COUNT - 1}` : `${size}`;
  return ` ${num} ${unit}`;
}

function formatFileSize(size) {
  if (size == null) return [0, "B"];
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
  if (size == 0) return [0, "B"];
  const i = parseInt(Math.floor(Math.log(size) / Math.log(1024)));
  const raw = size / Math.pow(1024, i);
  let value;
  if (i > 0 && raw < 999.95) {
    value = Math.round(raw * 10) / 10;
  } else {
    value = Math.round(raw);
  }
  return [value, sizes[i]];
}

function formatDuration(seconds) {
  seconds = Math.ceil(seconds);
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds - h * 3600) / 60);
  const s = seconds - h * 3600 - m * 60;
  return `${padZero(h, 2)}:${padZero(m, 2)}:${padZero(s, 2)}`;
}

function formatPercent(percent) {
  if (percent > 10) {
    return percent.toFixed(1) + "%";
  } else {
    return percent.toFixed(2) + "%";
  }
}

function encodedStr(rawStr) {
  return rawStr.replace(/[\u00A0-\u9999<>\&]/g, function (i) {
    return '&#' + i.charCodeAt(0) + ';';
  });
}

async function requestOk(url, options = {}) {
  const res = await fetch(url, options);
  if (res.ok) return res;

  const detail = await res.text();
  throw new Error(detail || `${res.status} ${res.statusText}`);
}

function getEncoding(contentType) {
  const charset = contentType?.split(";")[1];
  if (/charset/i.test(charset)) {
    let encoding = charset.split("=")[1];
    if (encoding) {
      return encoding.toLowerCase();
    }
  }
  return 'utf-8';
}

function parseIndexData(rawData) {
  const encodedData = rawData.trim();
  if (!encodedData || encodedData === "__INDEX_DATA__") {
    throw new Error("Dufs index data is missing");
  }
  return JSON.parse(decodeBase64(encodedData));
}

// Parsing base64 strings with Unicode characters
function decodeBase64(base64String) {
  const binString = atob(base64String);
  const len = binString.length;
  const bytes = new Uint8Array(len);
  const arr = new Uint32Array(bytes.buffer, 0, Math.floor(len / 4));
  let i = 0;
  for (; i < arr.length; i++) {
    arr[i] = binString.charCodeAt(i * 4) |
      (binString.charCodeAt(i * 4 + 1) << 8) |
      (binString.charCodeAt(i * 4 + 2) << 16) |
      (binString.charCodeAt(i * 4 + 3) << 24);
  }
  for (i = i * 4; i < len; i++) {
    bytes[i] = binString.charCodeAt(i);
  }
  return new TextDecoder().decode(bytes);
}
