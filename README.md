[!lab logo](https://static.wixstatic.com/media/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png/v1/crop/x_0,y_410,w_2160,h_361/fill/w_1315,h_220,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/0f3704_e795eb7b0f4c4f23851fc3d1a623c7cd~mv2.png)

# Introduction
The given pipeline helps to quantify the morphological and migratory dynamics of cells

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
 - Settings > 
