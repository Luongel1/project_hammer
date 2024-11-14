# project_hammer

This paper presents a statistical analysis of grocery pricing dynamics in Canada, focusing on the factors influencing current prices across major retailers using data from Project Hammer. By employing a Bayesian regression model, we examine the impact of previous prices, vendor identities, and recent price changes on current grocery prices. The analysis reveals that previous pricing patterns, vendor-specific strategies, and recent price adjustments significantly influence current prices, highlighting the role of market positioning and competitive pricing among Canadian grocery vendors. The model demonstrates substantial variations in pricing strategies across retailers, with some vendors maintaining consistently higher or lower prices. Additionally, price stability is observed, with previous prices showing a strong predictive effect on current prices. These findings offer insights into the grocery sector's competitive landscape and provide implications for both consumer cost-saving strategies and policy interventions aimed at promoting fair pricing practices.

## File Structure
The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from FiveThirtyEight.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage

Aspects of the abstract, title, and code such as the simulation script, cleaning script, testing script, and the Quarto paper were written with the help of chatGPT-4o and the entire chat history is available in other/llms/usage.txt.
