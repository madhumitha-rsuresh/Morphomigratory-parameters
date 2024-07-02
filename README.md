![lab logo](https://static.wixstatic.com/media/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png/v1/crop/x_0,y_410,w_2160,h_361/fill/w_1315,h_220,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png)

# Introduction
The morphological state and migratory dynamics of cells are widely imaged and analyzed these days to understand cellular behavior during morphogenesis and disease progression. Here, we constructed a curated toolbox incorporating a set of parameters to quantify the morpho-migratory dynamics of cells, focusing on the flux and interdependence of the two traits. The toolbox includes fitted ellipse parameters to measure cell geometry based on elongation dynamics (example: to understand protrusion formation or retraction), cell trajectory based on turning and displacement angles (example: to differentiate directed and random motion) and cell orientation based on angle between the major axis and displacement vector.

# Table of Contents
| S.No. | Title | 
| -- | -------- |
| 1. | [Required Softwares/Plugins](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/tree/main?tab=readme-ov-file#1-required-softwaresplugins--) |
| 2. | [Image Processing](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/tree/main?tab=readme-ov-file#2-image-processing) 
| 3. | [Analyze Particles](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/tree/main?tab=readme-ov-file#3-analyze-particle) |
| 4. | [Generation of tables and plots](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#4-generation-of-tables-and-plots) |

# 1. Required Softwares/Plugins <img src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/1dbc9cef-6b4f-471c-aea6-16a070519b96" width = 25px height = 25px> <img src = "https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/65329143-8596-4f18-ad01-529964233482" width = 25px height = 25px>
- Fiji (Image processor)
- Codes used:
    - ImageJ Macro
    - MATLAB

# 2. Image Processing
The below steps are for getting binarized image stacks from time-lapse videos containing fluorescently-labelled cells.

## Save your raw data file (time-lapse video) in .tif format
  - Make sure the videos are of higher resolution and of lesser background noise
  - The file should contain 't' slices, where t indicates the number of timeframes. Example: For a time-lapse of 2 hours with images taken every 2 minutes, there would be 61 frames (including at point t=0).
![C1-014_crop1_slice35](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/02876ce2-b166-4ad8-966c-2c4146feb990)

## Thresholding and Binarization
  - Open .tif file in Fiji
  - Image > Adjust > Brightness/Contrast
  - Image > Adjust > Threshold (Auto) > Apply > Create new stack > **Save** this file as **Binarized_image**
![adj](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/26075d6e-7edd-465d-89b6-f53edf549e2e) ![Binary_image_slice35](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/f20d6108-fac9-4e58-84cb-1e4a896af6d4)

# 3. Analyze Particle
Note: Make sure the scale is set before analyzing the image (Analyze > Set Scale)
- Set measurements > Fit ellipse, Area, Perimeter, Centroid, Shape descriptors, Stack position :ballot_box_with_check: 
- Analyze > Analyze Particles > Set Size according to cell size range; show 'outlines'

## Files to Save
1. ROI set
2. Drawing of Binary_image_processed_001 (for visualization and reference number)
3. Results as .csv

- For ellipse visualisation > **Code: 'ellipse_visualisation.ijm'**
- ROI set can be used for overlaying of outline to the ellipse
- Save as 'Processed_stack_ellipses.tif'

# 4. Generation of tables and plots
The following is used to obtain a table with values of different angles, velocity, distance, elongation and shape index.
- The results will have information of all the particles/cells/objects for every stack in one sheet
- Copy it into a new excel sheet - **Results_001_working.xlsx**
- Sort each object of every time frame (i.e. every slice) manually into specific sheets and label it as 'Object1', 'Object2' and so on.
- The example column order used is shown below (Time addition and sorting has been done manually)
<img width="656" alt="excel_sheet" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/0165e1af-aabe-4365-8550-a944b8873183">

- **Parameters table generation** - 'tablegeneration.m'
- **Entropy Table and histogram generation** - 'entropycalculation.m'
- **Parameter Plot generation** - 'parameterplots.m'
- **MSD and RMS(metric) calculation** - 'MSD_Calculation.m'
