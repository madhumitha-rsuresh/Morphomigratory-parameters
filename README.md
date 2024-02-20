![lab logo](https://static.wixstatic.com/media/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png/v1/crop/x_0,y_410,w_2160,h_361/fill/w_1315,h_220,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png)

# Introduction
The morphological state and migratory dynamics of cells are widely imaged and analyzed these days to understand cellular behavior during morphogenesis and disease progression. Here, we constructed a curated toolbox incorporating a set of parameters to quantify the morpho-migratory dynamics of cells, focusing on the flux and interdependence of the two traits. The toolbox includes fitted ellipse parameters to measure cell geometry based on elongation dynamics (example: to understand protrusion formation or retraction), cell trajectory based on turning and displacement angles (example: to differentiate directed and random motion) and cell orientation based on angle between the major axis and displacement vector.

# Table of Contents
| S.No. | Title | 
| -- | -------- |
| 1. | [Required Softwares/Plugins](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#1-required-softwaresplugins--) |
| 2. | [Image Segmentation](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#2-image-segmentation) 
|   | 2.1. [Saving raw file](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#21-save-your-raw-data-file-time-lapse-video-in-tif-format) |
|   | 2.2. [Segmentation](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#22-segmentation) |
|   | 2.3. [Training models](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#23-training-model) |
|   | 2.4. [Saving output files](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#24-saving-output-files)|
| 3. | [Binarization](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#3-binarization) |
| 4. | [Processing binarized image](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters#4-processing) |
| 5. | [Analyze Particles](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters?tab=readme-ov-file#5-analyze-particle) |
| 6. | [Generation of tables and plots](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#6-generation-of-table) |
|   | 6.1. [Parameters table](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#61-parameters-table-generation) |
|   | 6.2. [Entropy table](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#62-entropy-table-and-histogram-generation) |
|   | 6.3. [Parameters plots](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#63-plot-generation) |

# 1. Required Softwares/Plugins <img src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/1dbc9cef-6b4f-471c-aea6-16a070519b96" width = 25px height = 25px> <img src = "https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/65329143-8596-4f18-ad01-529964233482" width = 25px height = 25px>
- Fiji (Image processor)
- Trainable Weka Segmentation (plugin)
- Codes used:
    - ImageJ Macro
    - MATLAB

# 2. Image Segmentation
The below steps are for segmenting single cells from bright-field time-lapse videos. The following can be extended to flourescent videos too, starting from Step 3.

## 2.1. Save your raw data file (time-lapse video) in .tif format
  - Make sure the bright-field videos are of higher resolution and of lesser background noise
  - The file should contain 't' slices, where t indicates the number of timeframes. Example: For a time-lapse of 2 hours with images taken every 2 minutes, there would be 61 frames (including at point t=0).
<img width="500" alt="raw_file" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/d935ad37-6801-4afd-9510-af4aba3efa41">

## 2.2. Segmentation
  - Open .tif file in Fiji
  - Plugins > Segmentation > Trainable Weka Segmentation
<img width="667" alt="trainable_weka_segmentation" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/14f34d53-8c38-4982-b711-d3e54dbcd8c3">

**Note:** Refer to ImageJ Wiki Link for understanding the working of [Trainable Weka Segmentation](https://imagej.net/plugins/tws/)

### Trainable Weka Segmentation
 - Settings > **Class Names** > Ok
   **Class 1** - Cells
   **Class 2** - Background

## 2.3. Training Model
### Method 1
- Manually train the model by giving reference templates for 'cells' and 'background' as shown below.
- Click on **'Train Classifier'** 
<img width="824" alt="Segmentation process" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/4deb6227-806d-438e-abd7-e9e02f9de2c0">

#### Method 2
- Some trained models have been uploaded in the folder **'classifer models'** for cell types - OVCAR3 and SKOV3.
- Click on **'Load Classifier'** and upload the given model.
- Click on **'Create result'**

## 2.4. Saving Output Files:
1. **'Create result'** - Save as 'classified_image_001' (.tif)
<img width="500" alt="Classified_image" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/3495bfd3-4ae7-40bf-b5d2-7dd2174f83fa">

2. **'Get probability'** - Save as 'Probability_maps_001' (.tif)
<img width="500" alt="Probability_maps" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/8e0a649c-93f2-430f-adae-679805bdabb8">

3. Save **'Classifier model'** if done by Method 1

# 3. Binarization
The below steps are for converting 'probability maps' into binarised image sequences for further analysis.
- Open 'Probability_maps_001' in Fiji
- Image > Colour > Split Channels > Save the first channel where **cells** are given a probability **closer to '1'** and **background** as a probability **closer to '0'**.
- Image > Type 8-bit
- Process > Binary > Make Binary > :ballot_box_with_check: Create New stack
- Save as 'Binary_image_001' (.tif)
<img width="565" alt="Binarized_image" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/67e2e307-6d19-4c27-9397-9f667f3fd1cf">

# 4. Processing
From the obtained **'Binary_image_001'**, processing is performed to reduce background noise. 
- Process > Noise > Remove outliers > Adjust radius according to your image segmentation
<img width="485" alt="Remove_outliers" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/694cdf43-f7e0-40d4-8c64-d78c986dcbf2">

- Process > Binary > Options > Erode > Set 'iteration' according to your image segmentation
- Process > Binary > Fill Holes
<img width="193" alt="Erode" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/d57df4a9-6990-4e62-9ebb-944879873fcf">

- Save as **'Binary_image_processed_001'**
<img width = "500" src = "https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/cae00b81-4e2c-4e1f-8825-087ca244b969">

# 5. Analyze Particle
Note: Make sure the scale is set before analyzing the image (Analyze > Set Scale)
- Set measurements > Fit ellipse, Area, Perimeter, Centroid, Shape descriptors, Stack position :ballot_box_with_check: 
- Analyze > Analyze Particles > Set Size according to cell size range

<img width="208" alt="Analyze_particles" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/efda3d69-0c01-4862-98c9-dec8b1ee0759">

## Files to Save
1. ROI set
2. Drawing of Binary_image_processed_001 (for visualization and reference number)
3. Results as .csv

- For ellipse visualisation > **Code: 'ellipse_visualisation.ijm'**
- ROI set can be used for overlaying of outline to the ellipse
<img width="487" alt="Processed_stack_with_overlay" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/0fa68579-a643-424d-87fd-4e820f526483">

- Save as 'Processed_stack_ellipses.tif'

# 6. Generation of tables and plots
The following is used to obtain a table with values of different angles, velocity, distance, elongation and shape index.
- The results will have information of all the particles/cells/objects for every stack in one sheet
- Copy it into a new excel sheet - **Results_001_working.xlsx**
- Sort each object of every time frame (i.e. every slice) manually into specific sheets and label it as 'Object1', 'Object2' and so on.
- The example column order used is shown below (Time addition and sorting has been done manually)
<img width="656" alt="excel_sheet" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/0165e1af-aabe-4365-8550-a944b8873183">

## 6.1. Parameters table generation
**MATLAB Code: 'tablegeneration.m'**

 ![parameter range](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/825a9cb2-02df-4ef1-8f8e-1d4b8241bece)
 
## 6.2. Entropy Table and histogram generation
**MATLAB Code: 'entropycalculation.m'**

Sample histogram for a single-cell: <img src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/c90e18bd-3538-4c67-a23c-229da108dd62">

## 6.3. Plot generation
**MATLAB Code: 'parameterplots.m'**

Sample parameter plot for a single-cell: <img src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/5a120244-980a-4c25-befa-75dcf599300d">
