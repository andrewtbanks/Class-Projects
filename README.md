# Class-Projects
Codes and documentation for a few class projects


_______________________________________________________________________________________________________________________________________
GEOSTATISTICS-- Predicting_RGB_Image_Hues_Kriging_and_KNN

The directory \Predicting_RGB_Image_Hues_Kriging_and_KNN contains MATLAB codes for the final project in a geostatistics course

This project involved a comparison between Kriging (gaussian process regression) methods and the K-nearest neighbors algorithim for predicting spatial data given a small number of sampling points.

A 3 channel (red, geen and blue intensities) image of a hamburger is sampled a small number of times. theses sampling points are used with both esitmation methods. 

The project report is included as a .pdf file (project_report_Banks_GEOL791_Geostatistics.pdf)

The script 'KNN_predictions' can be run to see some example results for predictions using k-nearest neighbors algorithim. 

The script 'Kriging_predictions' can be run to see some example results for predictions using a universal kriging algorithim.

The codes in the folder \supprt_codes were acquired online and handle the kriging predictions.  

_______________________________________________________________________________________________________________________________________
CONTAMINANT TRANSPORT -- Analytical solution for transport along a single fracture

The directory \Transport_Along_Fracture_Analytical_Solution contains VBA codes for the final project in a contaminant transport course.

This project involved simulating contaminant transport along a single fracture using analytical solutions derived in the work of: 
Tang, D. H., Frind, E. O., and Sudicky, E. A. ( 1981), Contaminant transport in fractured porous media: Analytical solution for a single fracture, Water Resour. Res., 17( 3), 555– 564, doi:10.1029/WR017i003p00555.

A pdf of this paper is included (Tang_et_al-1981-Water_Resources_Research.pdf)

Solutions for transport along the fracture, and into the surrounding matrix were programmed using the VBA features in EXCEL.

To make the problem interesting, the method of superposition was used to enforce time dependent boundary conditions (in the form of varying contaminant source concentrations at the origin of the fracture). 

Results can be seen in the excel document 'Fracture_Transport_Tang1981.xlsx' and the source code can be seen by navigating to the 'developer' tab in the excel sheet and selecting the "visual basic" button. 

The final project report took the form of a power point presentation, included in the directory as 'Presentation_Fracture_Transport_Tang1981.ppt'

