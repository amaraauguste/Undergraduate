/** 
 * Amara Auguste
 * Used to create an API object which holds the names of
 * the images analyzed and the corresponding tags
 * provided by each API 
 */

package imagerecognitionapis;

import java.io.*;
import java.util.Scanner;

public class API {

    public static String[] imageList;
    public static String[] tags;

    API(int n) {
        imageList = new String[n];
        tags = new String[n];
    }

    public static void read(File f) throws FileNotFoundException {
        Scanner scan = new Scanner(f);

        for (int i = 0; i < imageList.length; i++) {
            imageList[i] = scan.next();
            tags[i] = scan.nextLine();
        }
    }

    
    public String getImage(int i){
        return imageList[i];
    }
    
    public String getTags(int i){
        return tags[i];
    }
    
    
    public static void print() {
        for (int i = 0; i < imageList.length; i++) {
            System.out.print(imageList[i] + "\t");
            System.out.print(tags[i] + "\n");
        }
    }
    
    public static int compare (API a){
        int count = 0;
        for(int i = 0; i < imageList.length; i++){
            if(imageList[i].equals(a.imageList[i])){
                if(tags[i].equals(a.tags[i])){
                    count++;
                }
            }
        }
        
        return count;
    }
}
