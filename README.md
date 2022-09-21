# CORTEZA Connector for Power BI

This is a Power BI connector for Corteza. Installing it into Power BI Desktop allows you to pull Corteza Module Records into Power BI for data manipulation and business intelligence reports.

To install, copy the Corteza.mez file from the bin folder and paste it into the Documents/Power BI Desktop/Custom Connectors folder in your computer. 

The current version of the connector only allows individual module record retrieval at a time. You will need to create an auth client and a system user on Corteza. Follow the instructions on the following links for more info

https://docs.cortezaproject.org/corteza-docs/2022.3/integrator-guide/accessing-corteza/index.html

Follow the instructions for setting up a specific API endpoint for Power BI

In Power BI, look for the Corteza connector under the Get Data function and click on it. Key in your auth client URL, your API URL, the namespace ID of the app you want to access, and the module ID of the module records you want to retrieve. After clicking OK, you will be directed to authenticate with the Corteza server. Key in the user id and the secret provided to you in the auth client setup page. upon completion, you will now have a table of the records from the module whose ID you provided earlier imported into Power BI.

In the future, when the implementation of the OpenApi3 library in Power BI is released, this connector will be able to more efficiently integrate with Corteza.  