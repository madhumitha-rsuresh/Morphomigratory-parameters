// Batch Process for Fitting Ellipses in ImageJ with Visualization
path=getDirectory("Choose a data folder");
	
// Open the image stack
open("Binary_image_processed_001.tif");
run("Set Scale...", "known=1.00 unit=micron");

//micronsPerPixel = getNumber("Enter the pixel size in microns:", 1);
micronsPerPixel = 1.6665; // conversion factor

// Set measurement parameters
run("Set Measurements...", "area centroid perimeter fit stack redirect=None decimal=3");

// Get the number of slices in the stack
n = nSlices();

// Create an empty list to store processed slices
processedSlices = newArray(n);

// Process each slice
for (slice = 1; slice <= n; slice++) {
	
    // Select the current slice
    selectImage("Binary_image_processed_001.tif");
    setSlice(slice);

    // Analyze Particles for the current slice
    run("Analyze Particles...", "size=300-infinity pixel display exclude circularity=0 include holes exclude on edges show=Ellipses display exclude clear ");
    
    // Process each result in the current slice
    for(i = 0; i < nResults; i++) {
    	x = getResult('X', i) * micronsPerPixel;
    	y = getResult('Y', i) * micronsPerPixel;
    	
    	// Scaling major axis
    	d = getResult('Major', i) * micronsPerPixel;
   		a = getResult('Angle',i)*PI/180;
   		setColor("blue"); // sets Blue color
   		drawLine(x + (d / 2) * cos(a), y - (d / 2) * sin(a), x - (d / 2) * cos(a), y + (d / 2) * sin(a));

    	// Scaling minor axis
    	d = getResult('Minor', i) * micronsPerPixel;
    	a = a + PI / 2;
    	setColor("red"); // sets Red color
    	drawLine(x + (d / 2) * cos(a), y - (d / 2) * sin(a), x - (d / 2) * cos(a), y + (d / 2) * sin(a));
    }
    	
   // Save the current slice as a new image
   title = "Processed_Slice_" + slice;
   saveAs("Tiff", title);
   processedSlices[slice - 1] = title;
   
   //Save the current slice result table
   //titletable = "rt" + slice;
  //IJ.renameResults(titletable);
   
   // Clear Overlay for the current slice
   run("Overlay Options...", "opacity=0");
   }
   
// Create a stack from the saved images
run("Images to Stack", "name=Processed_Stack title=[] use");
for (i = 0; i < n; i++) {
	run("Add...", "image=" + processedSlices[i]);
	File.delete(processedSlices[i]); // Delete temporary image
	}

