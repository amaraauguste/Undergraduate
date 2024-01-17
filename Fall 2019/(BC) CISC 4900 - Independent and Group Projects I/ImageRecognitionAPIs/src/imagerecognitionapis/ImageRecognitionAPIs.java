/** 
 * Amara Auguste
 * Image Recognition API Evaluator:
 * Evaluates the API results from Gaurav Oberoi's Open Source tool --- Cloudy Vision, 
 *  to test the image labeling capabilities of different computer vision API vendors, found here: 
 * https://github.com/goberoi/cloudy_vision. Uses the Apache Commons IO library to generate and write output 
 * to an html file and JFreeChart to create and display visual representation of the statistical data.
 */

package imagerecognitionapis;

import java.util.*;
import java.io.*;
import java.util.regex.*;
import javax.swing.SwingUtilities;
import org.apache.commons.io.FileUtils;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

public class ImageRecognitionAPIs {

    public static char percentSymbol = '%';

    public static void main(String[] args) throws FileNotFoundException, IOException {
       
        //allow for customizable output file name(s)
        Scanner k = new Scanner(System.in);
        System.out.print("What would you like to name your output file(s)?\nEnter name here (Enter 'N/A' or 'n/a' to use default name): ");
        String title = k.nextLine();
        if(title.equalsIgnoreCase("N/A")){
            title = "output";
        }
        k.close();
        
        //place names of all images to be evaluated in "images.txt" 
        File imageList = new File("info/images.txt");
        Scanner sc = new Scanner(imageList);
        PrintWriter p = new PrintWriter(title + ".txt");
        ArrayList<Object> images = new ArrayList<>();
        while (sc.hasNext()) {
            images.add(sc.next());//read image names into arraylist
        }
        Object[] imagesArray = images.toArray();//convert arraylist to array
        sc.close();

        File htmlTemplateFile = new File("template.html");
        String htmlString = FileUtils.readFileToString(htmlTemplateFile);
        htmlString = htmlString.replace("$total", "Number of images to evaluate: " + imagesArray.length);

        p.printf("Number of images to evaluate: %d\n", imagesArray.length);
        p.println("------------------------------------------------");

        File manualFile = new File("info/manualResults.txt");
        Scanner manual = new Scanner(manualFile);
        Map<String, String> manualEvaluation = new LinkedHashMap<>();//stores manual results for APIs to compare to
        //String imageName = "";
        while (manual.hasNext()) {
            String imageName = manual.next();//key
            String temp = manual.nextLine();//
            String s = removeDuplicates(temp);
            manualEvaluation.put(imageName, s);
        }

        manual.close();

        htmlString = evaluateAPIs(imagesArray, manualEvaluation, p, htmlString);//evaluates all .txt files in the 'vendors' folder

        File newHtmlFile = new File(title + ".html");//html output file
        FileUtils.writeStringToFile(newHtmlFile, htmlString);//writes to html
        p.close();
    }//end of main

    /**
     * Removes duplicate words/strings found in manual evaluations by converting to LinkedHashSet  
     */
    public static String removeDuplicates(String temp){
        String [] terms = temp.split("//W+");
        LinkedHashSet<String> lhs = new LinkedHashSet<> (Arrays.asList(terms));
        Object [] noDuplicates = lhs.toArray();
        String s = "";
        for(int i = 0; i < noDuplicates.length; i++){
            s += noDuplicates[i];
        }
        return s;
    }
    
    /**
     * Iterates through the 'vendors' directory and compares the manual results to the results from each API .txt file, calling containsExact to determine
     * whether or not the tags match and keeping count of tags that match, printing results to an output file.
     */
    public static String evaluateAPIs(Object[] images, Map<String, String> m, PrintWriter p, String htmlString) throws FileNotFoundException, IOException {
        File folder = new File("./vendors");//folder/directory where input files are located
        File[] listOfFiles = folder.listFiles();//array of files
        int numOfFiles = listOfFiles.length;//# of APIs to be evaluated

        API[] API_List = new API[numOfFiles];
        int[] countResults = new int[numOfFiles];//parallel arrays to store evaluation results
        double[] percent = new double[numOfFiles];//parallel arrays to store evaluation results
        double[] averageTags = new double[numOfFiles];//holds number of average tags per image via each API
        int totalTagsCount = 0;

        String body = "";
        String result = "";
        System.out.println("Evaluation completed for: ");
        System.out.println("--------------------------");

        int i = 0;
        for (File file : listOfFiles) {
            if (file.isFile()) {
                System.out.println(file.getName());
                API_List[i] = new API(images.length);
                API.read(listOfFiles[i]);//reads data from API file(s)

                for (int j = 0; j < images.length; j++) {//runs for each image to be evaluated
                    if (m.containsKey(API_List[i].getImage(j))) {//if image name exists in manual evaluation
                        String temp = m.get(API_List[i].getImage(j));//returns the string of tags found in manual evaluation 
                        String s = removeDuplicates(temp);
                        String[] words = s.split("\\W+");//split tags into array
                        for (int k = 0; k < words.length; k++) {//iterate through array of tags
                            if (containsExact(API_List[i].getTags(j), words[k])) {
                                countResults[i]++;//increment counter
                            }
                            totalTagsCount++;
                        }
                    }
                }

                averageTags[i] = computeAvgTags(API_List[i], images);//computes average number of tags provide per image from each API
                result += "Average tags per image for " + listOfFiles[i].getName() + " is: " + (int) averageTags[i] + "<br><br>";
                percent[i] = ((double) countResults[i] / totalTagsCount) * 100;//computes accuracy percentage
                p.printf("For '%s', accuracy in comparison to manual evaluation: %d out of %d (tags) or %.2f%c\n", listOfFiles[i].getName(), countResults[i], totalTagsCount, percent[i], percentSymbol);
                body += "For " + listOfFiles[i].getName() + ", accuracy in comparison to manual evaluation: " + countResults[i] + " out of " + totalTagsCount + " (tags) or " + String.format("%.2f", percent[i]) + percentSymbol + "<br><br>";
                totalTagsCount = 0;

                i++;
            }
        }

        p.println();

        if (numOfFiles >= 1) { //if one or more APIs are to be evaluated, compare results for accuracy
            htmlString = accuracy(listOfFiles, countResults, percent, p, htmlString, averageTags);
        }

        p.println("\nAverage Tags Per Image: ");
        p.println("--------------------------");
        String[] avg = result.split("<br><br>");
        for (int q = 0; q < avg.length; q++) {
            p.println(avg[q]);
        }

        createChart(listOfFiles, averageTags, "average tags", "Average Tags Per Image", "API", "Average Tags", "averageChart.png");//create chart of average tags
        p.println();

        htmlString = htmlString.replace("$evaluations", body);
        htmlString = htmlString.replace("$average", result);

        return htmlString;
    }

    /**
     * Searches String (sentence) for a full instance of a specific String (word)
     */
    public static boolean containsExact(String fullString, String partWord) {
        String pattern = "\\b" + partWord + "\\b";
        Pattern p = Pattern.compile(pattern);
        Matcher m = p.matcher(fullString);
        return m.find();
    }

    /**
     * Orders the results: creates and displays ranked list based on accuracy in descending order states most and least accurate APIs based on results
     */// double[] averageTags
    public static String accuracy(File[] f, int[] countResults, double[] percent, PrintWriter p, String htmlString, double[] averageTags) throws IOException {

        p.println("API Rankings (Most to least accurate): ");
        p.println("---------------------------------------");
        int temp;
        double temp2;
        double temp3;
        File tempF;
        String body = "";
        for (int i = 0; i < (countResults.length - 1); i++) {//sorts the results in descending order in order to rank them
            for (int j = 0; j < countResults.length - i - 1; j++) {
                if (countResults[j] < countResults[j + 1]) {
                    temp = countResults[j];
                    countResults[j] = countResults[j + 1];
                    countResults[j + 1] = temp;

                    temp2 = percent[j];
                    percent[j] = percent[j + 1];
                    percent[j + 1] = temp2;

                    temp3 = averageTags[j];
                    averageTags[j] = averageTags[j + 1];
                    averageTags[j + 1] = temp3;

                    tempF = f[j];
                    f[j] = f[j + 1];
                    f[j + 1] = tempF;

                }
            }
        }

        for (int k = 0; k < countResults.length; k++) {
            int place = k + 1;//rank
            p.printf("%d) '%s': %.2f%c accuracy\n", place, f[k].getName(), percent[k], percentSymbol);
            body += place + ") " + f[k].getName() + ": " + String.format("%.2f", percent[k]) + percentSymbol + "<br><br>";
        }

        htmlString = htmlString.replace("$rankings", body);
        p.println();

        int currentMax = countResults[0];
        int bestIdx = 0;
        int worstIdx = 0;
        for (int j = 1; j < countResults.length; j++) {
            if (countResults[j] > currentMax) {//compares results to find the most accurate
                currentMax = countResults[j];
                bestIdx = j;
            } else {
                worstIdx = j;
            }
        }

        createChart(f, percent, "percentage", "API Accuracy", "API", "Percentage", "percentageChart.png");//creates bar chart displaying accuracy percentages

        p.printf("Most accurate API is: '%s' at %.2f%c accuracy\n", f[bestIdx].getName(), percent[bestIdx], percentSymbol);//displays most accurate API
        p.printf("Least accurate API is: '%s' at %.2f%c accuracy\n", f[worstIdx].getName(), percent[worstIdx], percentSymbol);//displays most accurate API
        htmlString = htmlString.replace("$most", "Most accurate API is: " + f[bestIdx].getName() + " at " + String.format("%.2f", percent[bestIdx]) + percentSymbol + " accuracy " + "<br><br>");
        htmlString = htmlString.replace("$least", "Least accurate API is: " + f[worstIdx].getName() + " at " + String.format("%.2f", percent[worstIdx]) + percentSymbol + " accuracy " + "<br><br>");

        return htmlString;
    }

    /**
     * Creates bar chart with data from the API accuracy percentage(s) and saves as .png file to be displayed in the .html file
     */
    public static void createChart(File[] f, double[] data, String dataValue, String chartName, String X, String Y, String saveImageName) throws IOException {

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        for (int i = 0; i < f.length; i++) {
            dataset.addValue(data[i], dataValue, f[i].getName());
        }

        JFreeChart barChart = ChartFactory.createBarChart(
                chartName,
                X,
                Y,
                dataset,
                PlotOrientation.VERTICAL,
                false, true, false);

        ChartUtilities.saveChartAsPNG(new File("images/" + saveImageName), barChart, 400, 300);//saves chart as png image

    }

    /**
     * Counts up tags for each image from each API
     * divides that total by the number of images analyzed
     * to compute average number of tags per image
     */
    public static int computeAvgTags(API API_List, Object[] images) {
        int sum = 0;
        for (int i = 0; i < API_List.tags.length; i++) {
            if (API_List.tags[i] != null || !(API_List.tags[i].isEmpty())) {
                String[] words = API_List.tags[i].split(",");
                sum += words.length;

            }
        }

        return sum / images.length;

    }

}
