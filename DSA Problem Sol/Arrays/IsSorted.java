
import java.util.Scanner;
public class IsSorted {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter the size of the array");
        int size = sc.nextInt();
        int[] arr = new int[size];

        System.out.println("Enter the values to fill array");
        for(int i = 0; i < arr.length; i++) {
            arr[i] = sc.nextInt();
        }

        boolean isAsc = true;

        for(int i = 0; i < arr.length - 1; i++) {
            if (arr[i] > arr[i + 1]) {
                isAsc = false;
                break;
            }
        }
        if (isAsc) {
            System.out.println("The array is sorted");
        }else{
            System.out.println("Array is unsorted");
        }
        sc.close();
    }
}
