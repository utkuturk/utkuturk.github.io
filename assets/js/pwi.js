// Version configurations
const versionConfigs = {
  phonological: {
    name: "Phonological PWI",
    soa: 300,  // positive = distractor AFTER picture
    description: "Phonological (onset) relatedness"
  },
  semantic: {
    name: "Semantic PWI",
    soa: -150,  // negative = distractor BEFORE picture
    description: "Semantic (coordinate) relatedness"
  },
  conceptual: {
    name: "Conceptual PWI",
    soa: -400,  // negative = distractor well BEFORE picture
    description: "Conceptual (superordinate) relatedness"
  }
};

// Stimulus sets for each version
const stimuliByVersion = {
  phonological: [
    // Phonological: onset overlap
    { picture: "🐕", name: "dog", related: "doll", unrelated: "lamp" },
    { picture: "🚗", name: "car", related: "cart", unrelated: "boot" },
    { picture: "🌳", name: "tree", related: "train", unrelated: "sock" },
    { picture: "📚", name: "book", related: "boot", unrelated: "fish" },
    { picture: "🏠", name: "house", related: "horse", unrelated: "bell" },
    { picture: "✈️", name: "plane", related: "plate", unrelated: "cork" },
    { picture: "🐱", name: "cat", related: "cap", unrelated: "milk" },
    { picture: "🌺", name: "flower", related: "flag", unrelated: "tent" },
    { picture: "👟", name: "shoe", related: "ship", unrelated: "frog" },
    { picture: "☀️", name: "sun", related: "sum", unrelated: "kite" },
    { picture: "🍎", name: "apple", related: "anchor", unrelated: "tiger" },
    { picture: "🪑", name: "chair", related: "chain", unrelated: "queen" },
  ],
  semantic: [
    // Semantic: category coordinates
    { picture: "🐕", name: "dog", related: "cat", unrelated: "table" },
    { picture: "🚗", name: "car", related: "truck", unrelated: "apple" },
    { picture: "🌳", name: "tree", related: "flower", unrelated: "chair" },
    { picture: "📚", name: "book", related: "magazine", unrelated: "shoe" },
    { picture: "🏠", name: "house", related: "apartment", unrelated: "banana" },
    { picture: "✈️", name: "plane", related: "helicopter", unrelated: "cup" },
    { picture: "🐱", name: "cat", related: "dog", unrelated: "lamp" },
    { picture: "🌺", name: "flower", related: "tree", unrelated: "phone" },
    { picture: "👟", name: "shoe", related: "boot", unrelated: "cloud" },
    { picture: "☀️", name: "sun", related: "moon", unrelated: "fork" },
    { picture: "🍎", name: "apple", related: "orange", unrelated: "desk" },
    { picture: "🪑", name: "chair", related: "table", unrelated: "fish" },
  ],
  conceptual: [
    // Conceptual: superordinate categories
    { picture: "🐕", name: "dog", related: "animal", unrelated: "vehicle" },
    { picture: "🚗", name: "car", related: "vehicle", unrelated: "fruit" },
    { picture: "🌳", name: "tree", related: "plant", unrelated: "tool" },
    { picture: "📚", name: "book", related: "reading", unrelated: "food" },
    { picture: "🏠", name: "house", related: "building", unrelated: "animal" },
    { picture: "✈️", name: "plane", related: "vehicle", unrelated: "plant" },
    { picture: "🐱", name: "cat", related: "animal", unrelated: "furniture" },
    { picture: "🌺", name: "flower", related: "plant", unrelated: "clothing" },
    { picture: "👟", name: "shoe", related: "clothing", unrelated: "animal" },
    { picture: "☀️", name: "sun", related: "celestial", unrelated: "food" },
    { picture: "🍎", name: "apple", related: "fruit", unrelated: "building" },
    { picture: "🪑", name: "chair", related: "furniture", unrelated: "vehicle" },
  ]
};

// Practice/burn-in trials - constant across all participants and versions
// These use different items than the main experiment
const practiceStimuli = {
  phonological: [
    { picture: "🚲", name: "bike", distractor: "bite", condition: "related" },
    { picture: "🐟", name: "fish", distractor: "lamp", condition: "unrelated" },
    { picture: "🌙", name: "moon", distractor: "XXXX", condition: "neutral" },
  ],
  semantic: [
    { picture: "🚲", name: "bike", distractor: "car", condition: "related" },
    { picture: "🐟", name: "fish", distractor: "lamp", condition: "unrelated" },
    { picture: "🌙", name: "moon", distractor: "XXXX", condition: "neutral" },
  ],
  conceptual: [
    { picture: "🚲", name: "bike", distractor: "vehicle", condition: "related" },
    { picture: "🐟", name: "fish", distractor: "furniture", condition: "unrelated" },
    { picture: "🌙", name: "moon", distractor: "XXXX", condition: "neutral" },
  ]
};

// Latin Square Design: 3 lists for counterbalancing
// Items 0-3 = Group A, Items 4-7 = Group B, Items 8-11 = Group C
// Each list assigns different conditions to each group
const latinSquare = {
  1: ["related", "unrelated", "neutral"],    // A=related, B=unrelated, C=neutral
  2: ["unrelated", "neutral", "related"],    // A=unrelated, B=neutral, C=related
  3: ["neutral", "related", "unrelated"]     // A=neutral, B=related, C=unrelated
};

// Experiment state
let currentVersion = null;
let currentList = null;
let trials = [];
let currentTrial = 0;
let currentBlock = 1;
let trialStartTime = 0;
let responseTime = 0;
let results = [];
let experimentPhase = "waiting";
let firstKeypressRecorded = false;

function selectVersion(version) {
  currentVersion = version;
  const config = versionConfigs[version];

  // Update UI
  document.getElementById("version-select").style.display = "none";
  document.getElementById("experiment-area").style.display = "block";

  // Show version badge
  const badge = document.getElementById("current-version");
  badge.textContent = config.name;
  badge.className = version;

  // Update timing diagram
  updateTimingDiagram(config.soa);
}

function updateTimingDiagram(soa) {
  const display = document.getElementById("timing-display");

  if (soa < 0) {
    // Distractor comes first
    display.innerHTML = `
      <span class="marker distractor">WORD</span>
      <span style="color: #7f8c8d;">&rarr; ${Math.abs(soa)}ms &rarr;</span>
      <span class="marker picture">PICTURE</span>
      <span style="color: #7f8c8d; margin-left: 10px;">(measure RT from picture)</span>
    `;
  } else {
    // Picture comes first
    display.innerHTML = `
      <span class="marker picture">PICTURE</span>
      <span style="color: #7f8c8d;">&rarr; ${soa}ms &rarr;</span>
      <span class="marker distractor">WORD</span>
      <span style="color: #7f8c8d; margin-left: 10px;">(measure RT from picture)</span>
    `;
  }
}

function backToSelection() {
  currentVersion = null;
  currentBlock = 1;

  // Exit fullscreen if active
  exitFullscreen();

  document.getElementById("version-select").style.display = "block";
  document.getElementById("experiment-area").style.display = "none";
  document.getElementById("results").style.display = "none";
  document.getElementById("start-btn").style.display = "inline-block";
  document.getElementById("back-btn").style.display = "inline-block";
  document.getElementById("instructions").style.display = "block";
  document.getElementById("response-input").style.display = "block";
  document.getElementById("response-text").disabled = true;
  document.getElementById("response-text").value = "";
  document.getElementById("submit-btn").disabled = true;
  document.getElementById("current-version").style.display = "inline-block";

  // Reset stimulus display
  document.getElementById("stimulus-display").innerHTML = `
    <div id="fixation">+</div>
    <div id="picture-container" style="display:none;">
      <div id="picture"></div>
      <div id="distractor-word"></div>
    </div>
  `;
}

function createTrials() {
  trials = [];
  const stimuli = stimuliByVersion[currentVersion];
  const practice = practiceStimuli[currentVersion];

  // Add practice/burn-in trials first (constant across all participants)
  practice.forEach((prac, index) => {
    trials.push({
      picture: prac.picture,
      targetName: prac.name,
      distractor: prac.distractor,
      condition: prac.condition,
      itemIndex: index,
      group: "practice",
      block: 0,  // Block 0 = practice
      isPractice: true
    });
  });

  // Randomly assign to a list (1, 2, or 3)
  currentList = Math.floor(Math.random() * 3) + 1;

  // Create two blocks with rotated Latin Square assignments
  // Block 1 uses currentList, Block 2 uses rotated list
  const block1List = currentList;
  const block2List = (currentList % 3) + 1;  // Rotate: 1->2, 2->3, 3->1

  const block1Conditions = latinSquare[block1List];
  const block2Conditions = latinSquare[block2List];

  // Create trials for both blocks
  [1, 2].forEach(blockNum => {
    const listConditions = blockNum === 1 ? block1Conditions : block2Conditions;
    const blockTrials = [];

    stimuli.forEach((stim, index) => {
      // Determine which group this item belongs to
      let group;
      if (index < 4) group = 0;       // Group A
      else if (index < 8) group = 1;  // Group B
      else group = 2;                  // Group C

      // Get the condition for this group based on the current block's list
      const condition = listConditions[group];

      // Set the distractor based on condition
      let distractor;
      if (condition === "related") {
        distractor = stim.related;
      } else if (condition === "unrelated") {
        distractor = stim.unrelated;
      } else {
        distractor = "XXXX";
      }

      blockTrials.push({
        picture: stim.picture,
        targetName: stim.name,
        distractor: distractor,
        condition: condition,
        itemIndex: index,
        group: ["A", "B", "C"][group],
        block: blockNum,
        isPractice: false
      });
    });

    // Shuffle trials within each block
    for (let i = blockTrials.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [blockTrials[i], blockTrials[j]] = [blockTrials[j], blockTrials[i]];
    }

    // Add block trials to main trials array
    trials.push(...blockTrials);
  });
}

function enterFullscreen() {
  const container = document.getElementById("experiment-area");
  container.classList.add("fullscreen-mode");

  // Try to request browser fullscreen API
  const docEl = document.documentElement;
  if (docEl.requestFullscreen) {
    docEl.requestFullscreen().catch(() => {});
  } else if (docEl.webkitRequestFullscreen) {
    docEl.webkitRequestFullscreen();
  } else if (docEl.mozRequestFullScreen) {
    docEl.mozRequestFullScreen();
  }
}

function exitFullscreen() {
  const container = document.getElementById("experiment-area");
  container.classList.remove("fullscreen-mode");

  if (document.exitFullscreen) {
    document.exitFullscreen().catch(() => {});
  } else if (document.webkitExitFullscreen) {
    document.webkitExitFullscreen();
  } else if (document.mozCancelFullScreen) {
    document.mozCancelFullScreen();
  }
}

function startExperiment() {
  createTrials();
  currentTrial = 0;
  currentBlock = 1;
  results = [];

  // Enter fullscreen mode
  enterFullscreen();

  document.getElementById("start-btn").style.display = "none";
  document.getElementById("back-btn").style.display = "none";
  document.getElementById("instructions").style.display = "none";
  document.getElementById("results").style.display = "none";
  document.getElementById("response-input").style.display = "block";
  document.getElementById("current-version").style.display = "none";

  runTrial();
}

function runTrial() {
  if (currentTrial >= trials.length) {
    showResults();
    return;
  }

  const trial = trials[currentTrial];
  const config = versionConfigs[currentVersion];
  const soa = config.soa;

  // Track current block from trial data
  currentBlock = trial.block;

  experimentPhase = "fixation";
  firstKeypressRecorded = false;

  // Update progress (don't mention blocks to participant)
  document.getElementById("progress").textContent =
    `Trial ${currentTrial + 1} of ${trials.length}`;

  // Show fixation
  document.getElementById("fixation").style.display = "block";
  document.getElementById("picture-container").style.display = "none";
  document.getElementById("feedback").textContent = "";

  // Disable input during fixation
  const inputEl = document.getElementById("response-text");
  const submitBtn = document.getElementById("submit-btn");
  inputEl.disabled = true;
  inputEl.value = "";
  submitBtn.disabled = true;

  // Variable fixation duration
  const fixationDuration = 500 + Math.random() * 500;

  setTimeout(() => {
    // Prepare stimulus display
    document.getElementById("fixation").style.display = "none";
    document.getElementById("picture-container").style.display = "flex";

    const pictureEl = document.getElementById("picture");
    const distractorEl = document.getElementById("distractor-word");

    pictureEl.textContent = trial.picture;
    distractorEl.textContent = trial.distractor;

    // Reset visibility
    pictureEl.classList.remove("visible");
    distractorEl.classList.remove("visible");

    if (soa < 0) {
      // NEGATIVE SOA: Distractor appears BEFORE picture
      distractorEl.classList.add("visible");

      setTimeout(() => {
        pictureEl.classList.add("visible");
        experimentPhase = "stimulus";
        trialStartTime = performance.now();
        enableInput();
      }, Math.abs(soa));

    } else if (soa > 0) {
      // POSITIVE SOA: Picture appears BEFORE distractor
      pictureEl.classList.add("visible");
      experimentPhase = "stimulus";
      trialStartTime = performance.now();
      enableInput();

      setTimeout(() => {
        distractorEl.classList.add("visible");
      }, soa);

    } else {
      // SOA = 0: Simultaneous
      pictureEl.classList.add("visible");
      distractorEl.classList.add("visible");
      experimentPhase = "stimulus";
      trialStartTime = performance.now();
      enableInput();
    }

  }, fixationDuration);
}

function enableInput() {
  const inputEl = document.getElementById("response-text");
  const submitBtn = document.getElementById("submit-btn");
  inputEl.disabled = false;
  submitBtn.disabled = false;
  inputEl.focus();
}

function recordFirstKeypress() {
  if (experimentPhase !== "stimulus" || firstKeypressRecorded) return;

  responseTime = performance.now() - trialStartTime;
  firstKeypressRecorded = true;
  experimentPhase = "responding";
}

function submitResponse() {
  if (experimentPhase !== "responding" && experimentPhase !== "stimulus") return;

  // If they hit enter without typing, record RT now
  if (!firstKeypressRecorded) {
    responseTime = performance.now() - trialStartTime;
  }

  const response = document.getElementById("response-text").value.trim().toLowerCase();
  const trial = trials[currentTrial];
  const correct = response === trial.targetName.toLowerCase();

  // Record result
  results.push({
    trial: currentTrial + 1,
    practice: trial.isPractice,
    block: trial.block,
    list: currentList,
    version: currentVersion,
    soa: versionConfigs[currentVersion].soa,
    item: trial.itemIndex + 1,
    group: trial.group,
    picture: trial.targetName,
    distractor: trial.distractor,
    condition: trial.condition,
    rt: Math.round(responseTime),
    response: response,
    correct: correct
  });

  // Disable input
  document.getElementById("response-text").disabled = true;
  document.getElementById("submit-btn").disabled = true;

  // Show feedback
  const feedbackEl = document.getElementById("feedback");
  if (correct) {
    feedbackEl.innerHTML = `<span class="correct">Correct! (${Math.round(responseTime)} ms)</span>`;
  } else {
    feedbackEl.innerHTML = `<span class="incorrect">The picture was: ${trial.targetName}</span>`;
  }

  experimentPhase = "feedback";

  // Next trial
  currentTrial++;
  setTimeout(runTrial, 1000);
}

function showResults() {
  experimentPhase = "waiting";
  const config = versionConfigs[currentVersion];

  // Exit fullscreen mode
  exitFullscreen();

  document.getElementById("stimulus-display").innerHTML =
    `<div id="fixation" style="font-size: 24px; color: #27ae60;">Experiment Complete!</div>`;
  document.getElementById("response-input").style.display = "none";
  document.getElementById("progress").textContent = "";
  document.getElementById("feedback").textContent = "";
  document.getElementById("current-version").style.display = "inline-block";

  // Calculate summary statistics (excluding practice trials)
  const experimentalTrials = results.filter(r => !r.practice);
  const correctTrials = experimentalTrials.filter(r => r.correct);
  const accuracy = (correctTrials.length / experimentalTrials.length * 100).toFixed(1);
  const meanRT = correctTrials.length > 0
    ? Math.round(correctTrials.reduce((sum, r) => sum + r.rt, 0) / correctTrials.length)
    : 0;

  // Calculate by condition (excluding practice trials)
  const conditions = ["related", "unrelated", "neutral"];
  const conditionStats = {};

  conditions.forEach(cond => {
    const condTrials = experimentalTrials.filter(r => r.condition === cond && r.correct);
    conditionStats[cond] = {
      n: condTrials.length,
      meanRT: condTrials.length > 0
        ? Math.round(condTrials.reduce((sum, r) => sum + r.rt, 0) / condTrials.length)
        : 0
    };
  });

  // Display summary
  const practiceCount = results.filter(r => r.practice).length;
  document.getElementById("summary-stats").innerHTML = `
    <div class="stat-box">
      <div class="value">List ${currentList}</div>
      <div class="label">Latin Square</div>
    </div>
    <div class="stat-box">
      <div class="value">${experimentalTrials.length}</div>
      <div class="label">Experimental Trials</div>
    </div>
    <div class="stat-box">
      <div class="value">${accuracy}%</div>
      <div class="label">Accuracy</div>
    </div>
    <div class="stat-box">
      <div class="value">${meanRT} ms</div>
      <div class="label">Mean RT</div>
    </div>
  `;

  // Display condition comparison
  const maxRT = Math.max(...Object.values(conditionStats).map(s => s.meanRT)) * 1.2 || 1000;

  const interferenceEffect = conditionStats.related.meanRT - conditionStats.unrelated.meanRT;
  const effectDirection = interferenceEffect > 0 ? "interference" : "facilitation";

  document.getElementById("condition-comparison").innerHTML = `
    <h4>Reaction Time by Condition</h4>
    <p><em>${config.name} (SOA: ${config.soa > 0 ? '+' : ''}${config.soa}ms) - ${config.description}</em></p>
    <p style="font-size: 12px; color: #95a5a6;">2-block Latin Square: 8 trials per condition (24 total trials)</p>
    ${conditions.map(cond => `
      <div class="condition-bar">
        <div class="condition-label">${cond.charAt(0).toUpperCase() + cond.slice(1)} (n=${conditionStats[cond].n})</div>
        <div class="bar-container">
          <div class="bar ${cond}" style="width: ${(conditionStats[cond].meanRT / maxRT * 100)}%">
            ${conditionStats[cond].meanRT} ms
          </div>
        </div>
      </div>
    `).join('')}
    <p style="margin-top: 15px; font-size: 14px; color: #7f8c8d;">
      <strong>${effectDirection.charAt(0).toUpperCase() + effectDirection.slice(1)} effect:</strong>
      ${Math.abs(interferenceEffect)} ms
      (Related ${interferenceEffect > 0 ? '>' : '<'} Unrelated)
    </p>
  `;

  // Display trial table (practice trials shown in grey)
  const tbody = document.getElementById("results-body");
  tbody.innerHTML = results.map(r => `
    <tr style="${r.practice ? 'color: #999; font-style: italic;' : ''}">
      <td>${r.trial}</td>
      <td>${r.practice ? 'P' : r.block}</td>
      <td>${r.item} (${r.group})</td>
      <td>${r.picture}</td>
      <td>${r.distractor}</td>
      <td>${r.condition}</td>
      <td>${r.rt}</td>
      <td>${r.response}</td>
      <td>${r.correct ? '✓' : '✗'}</td>
    </tr>
  `).join('');

  document.getElementById("results").style.display = "block";
}

function downloadResults() {
  const headers = ["trial", "practice", "block", "list", "version", "soa", "item", "group", "picture", "distractor", "condition", "rt", "response", "correct"];
  const csv = [
    headers.join(","),
    ...results.map(r => headers.map(h => r[h]).join(","))
  ].join("\n");

  const blob = new Blob([csv], { type: "text/csv" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `pwi_${currentVersion}_list${currentList}_${new Date().toISOString().slice(0,10)}.csv`;
  a.click();
}

function restartExperiment() {
  currentBlock = 1;

  document.getElementById("stimulus-display").innerHTML = `
    <div id="fixation">+</div>
    <div id="picture-container" style="display:none;">
      <div id="picture"></div>
      <div id="distractor-word"></div>
    </div>
  `;
  document.getElementById("start-btn").style.display = "inline-block";
  document.getElementById("back-btn").style.display = "inline-block";
  document.getElementById("instructions").style.display = "block";
  document.getElementById("results").style.display = "none";
  document.getElementById("response-input").style.display = "block";
  document.getElementById("response-text").disabled = true;
  document.getElementById("response-text").value = "";
  document.getElementById("submit-btn").disabled = true;
}

// Set up input event listeners
document.addEventListener("DOMContentLoaded", () => {
  const inputEl = document.getElementById("response-text");

  // Record RT on first keypress (any printable character)
  inputEl.addEventListener("keydown", (e) => {
    // Record first keypress for RT (ignore Enter, Tab, etc.)
    if (e.key.length === 1 && !e.ctrlKey && !e.metaKey) {
      recordFirstKeypress();
    }

    // Submit on Enter
    if (e.key === "Enter") {
      e.preventDefault();
      submitResponse();
    }
  });
});
