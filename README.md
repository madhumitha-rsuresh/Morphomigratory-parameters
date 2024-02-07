![lab logo](https://static.wixstatic.com/media/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png/v1/crop/x_0,y_410,w_2160,h_361/fill/w_1315,h_220,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png)

# Introduction
The morphological state and migratory dynamics of cells are widely imaged and analyzed these days to understand cellular behavior during morphogenesis and disease progression. Here, we constructed a curated toolbox incorporating a set of parameters to quantify the morpho-migratory dynamics of cells, focusing on the flux and interdependence of the two traits. The toolbox includes fitted ellipse parameters to measure cell geometry based on elongation dynamics (example: to understand protrusion formation or retraction), cell trajectory based on turning and displacement angles (example: to differentiate directed and random motion) and cell orientation based on angle between the major axis and displacement vector.

# Table of Contents
| S.No. | Title | 
| -- | -------- |
| 1. | [Required Softwares/Plugins](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#required-softwaresplugins) |
| 2. | [Image Segementation](https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/blob/main/README.md#image-segmentation) |
| 3. | Binarization |
| 4. | Analyse Particles |
| 5. | Generation of table |
| 6. | Generation of plots |

# Required Softwares/Plugins
- Fiji (Image processor)
- Trainable Weka Segmentation (plugin)
- Codes used: ImageJ Macro, MATLAB

# Image Segmentation
The below steps are for segmenting and analysing single cells from bright-field time-lapse videos. The following can be extended to flourescent videos too, starting from Step 3.

## Step 1
### 1. Save your raw data file (time-lapse video) in .tif format
  - Make sure the bright-field videos are of higher resolution and of lesser background noise
  - The file should contain 't' slices, where t indicates the number of timeframes. Example: For a time-lapse of 2 hours with images taken every 2 minutes, there would be 61 frames (inclusing at point t=0).
  
### 2. Segmentation
  - Open .tif file in Fiji
  - Plugins > Segmentation > Trainable Weka Segmentation
**Note:** Refer to ImageJ Wiki Link for understanding the working of [Trainable Weka Segmentation] (https://imagej.net/plugins/tws/)

#### Trainable Weka Segmentation
 - Settings > **Class Names** > Ok
   **Class 1** - Cells
   **Class 2** - Background

### 3. Training Model
#### Method 1
- Manually train the model by giving reference templates for 'cells' and 'background' as shown below: 
<img width="824" alt="Segmentation process" src="https://github.com/madhumitha-rsuresh/Morphomigratory-parameters/assets/88226429/4deb6227-806d-438e-abd7-e9e02f9de2c0">

- Click on **'Train Classifier'**
#### Method 2
- Some trained models have been uploaded in the folder 'classifer models' for cell types - OVCAR3 and SKOV3.
- Click on **'Load Classifier'** and upload the given model.
- Click on **'Create result'**

**Files to Save:**
1. 'Create result' - Save as 'classified_image_001'
2. "Get probability' - Save as 'Probability_maps_001'
3. Save 'Classifier model' if done by Method 1



