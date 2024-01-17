IMAGE RECOGNITION API EVALUATOR:

Evaluates the API results from Gaurav Oberoi's Open Source tool --- Cloudy Vision, to test the image labeling capabilities of different computer vision API vendors, found here: https://github.com/goberoi/cloudy_vision. Uses the Apache Commons IO library to generate and write output to an html file and JFreeChart to create and display visual representation of the statistical data. 

How it works/Usage:

1. After running cloudy_vision.py, record results for each API in a .txt file in the order of:
	"image filename"	"list of tags"
(So if evaluating AWS rekognition, Clarifai, and IBM Watson, etc. then each API needs it's own corresponding text file) and save recorded results from Cloudy Vision in individual .txt files and save in 'vendors' folder(if saving in notepad, deselect 'word wrap' under the 'format' menu).
2. Save list of image filenames to be evaluated in a .txt file named: "image.txt" and save manual evaluation (tags that the user wants the APIs to be compared to) in the 'info' folder.
3. Record results from manual evaluation (or whichever data that you would like to initially compare the API results to) in a text file titled ‘manualResults.txt’ with the same format as the API tags:
	"image filename"	"list of tags"
and save in 'info' folder (once again, if saving in notepad, deselect 'word wrap' under the 'format' menu). Limit (try not to feature at all) the use of duplicate terms and function words (prepositions, conjunctions, like: a, an, the, etc.) within the list of tags per each image
4. The data from each vendor .txt file is saved as an Object called 'API' with a String [] imageList and String [] tags respectively (API.java).
5. Runs through array of API objects, comparing tags found in the manual evaluation to tags found from an API (results may vary depending on the user's manual evaluation) and computes accuracy as a percentage.
6. If amount of APIs evaluated is greater than one, ranks the APIs based on descending accuracy and states the most and least accurate APIs and their percentages.
7. Computes accuracy percentage per API and average number of tags provided per image from each API and creates a bar chart displaying the results, saving the resulting charts in the 'images' folder as 'percentageChart.png' and 'averageChart.png' respectively.
8. Displays all resulting data to output.txt file and output.html file in the html format from the template.html file. 

04_14_2020: Update ImageRecognitionAPIs.java
- Added modifications to allow for customizable output file name(s) or to directions to use defaults ('output.txt' and 'output.html')
- Added removeDuplicates method that converts String of tags from user's manual evaluation to LinkedHashSet, thus removing any duplicate terms before reconverting to String [] array and appending to a returning String
