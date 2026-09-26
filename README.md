# 32VAN - Signals & Systems: DFT/DFT2 Project

Repository for Assignment A (Exercises 7.10–7.13 & 8.14–8.15).

---

## 📁 Repository Structure

```text
├── data/                  # Input audio, images, and recordings
│   └── voice/             # Place u_low.wav, u_high.wav, a_low.wav here
├── src/                   # MATLAB scripts organized by exercise
│   ├── ex7_10_dft_basics/
│   ├── ex7_11_cosine/
│   ├── ex7_12_violin/
│   ├── ex7_13_voice/      # Voice recordings analysis & comparisons
│   ├── ex8_14_smoothing/  # Newspaper smoothing (2D DFT convolution)
│   └── ex8_15_diffraction/# Fraunhofer diffraction (dft2_rect)
├── figures/               # Exported plots/images for the final report
└── report/                # Report source (LaTeX/Word) and final PDF
```

---

## 📏 Coding Guidelines (Appendix E Requirements)

1. **No Magic Numbers**: Declare all parameters and constants at the top of your script.
2. **Units & Comments**: Add comments explaining quantities, units (`[s]`, `[Hz]`, `[rad/m]`), and references to equations in the lecture notes (e.g., `%(eq. 8.21)`).
3. **Plot Quality**: Every figure **must** have:
   * Descriptive `title`
   * `xlabel` and `ylabel` with units
   * `grid on`
4. **Save Figures Automatically**: Build paths from the script's own folder, so the script runs from any current folder, and export into `figures/<exercise>/`:
   ```matlab
   script_dir = fileparts(mfilename('fullpath'));
   addpath(fullfile(script_dir, '..'));  % helpers in src/
   fig_dir = fullfile(script_dir, '..', '..', 'figures', 'ex7_12_violin');
   new_figure();
   % ... plot ...
   exportgraphics(gcf, fullfile(fig_dir, 'fig_name.png'), 'Resolution', 200);
   ```
   Open figures with `new_figure` (or `quickplot` for images), not `figure`: since R2025a MATLAB can draw figures in a dark theme, which ends up in the exported file.
5. **No `clear` in scripts**: it wipes the caller's workspace when a script is run from another one.

---

## 🌿 Git Workflow

* **`master`** is protected — only clean, working code goes here.
* Create a branch for your task: `git checkout -b feature/ex7-10`
* Test your script locally before pushing.
* Open a Merge Request (MR) in GitLab when ready.
