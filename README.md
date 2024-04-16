## What is this?
This project aims to automate in-app product pricing adjustments based on country GDP. By calculating the ratio between the base GDP (GDP<sub>base</sub>) and comparator GDP (GDP<sub>comparator</sub>) for each country, the script will adjust prices using the formula:

<b>Adjusted Price = Current Price * (GDP<sub>base</sub> / GDP<sub>comparator</sub>)</b>

<font color="red"><b>Notes: However, the script still has a problem. Sometimes, the price is too low or even zero, resulting in an error warning from the Play Store. To mitigate this issue, I implemented a temporary solution: if the price is zero, it will be multiplied by 10 first. I acknowledge that this is not an ideal solution, but it has proven to be effective in my case. Please adjust it to fit your specific scenario.</b></font>

## Instructions
- Export your pricing CSV from Play Console
![export](images/export.jpg)
- Move CSV file to root of the project and rename it to `pricing.csv`
- Adjust your base GDP on `currentGdp` variable
- Run the script using `dart main.dart`
- Import `output.csv` into Play Console
![export](images/import.jpg)