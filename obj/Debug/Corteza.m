// This file contains your Data Connector logic
section Corteza;

[DataSource.Kind="Corteza", Publish="Corteza.Publish"]
shared Corteza.Contents = (Auth_url as text, Api_url as text, Namespace as text, optional Module as text) =>
    let
        user_id = Extension.CurrentCredential()[Username],
        secret = Extension.CurrentCredential()[Password],
        Token = GetToken(Auth_url, user_id, secret),
        result = GetData(Token[access_token], Api_url, Namespace, Module),
        #"Converted to Table" = Record.ToTable(result),
        #"Expanded Value" = Table.ExpandRecordColumn(#"Converted to Table", "Value", {"filter", "set"}, {"Value.filter", "Value.set"}),
        #"Removed Columns" = Table.RemoveColumns(#"Expanded Value",{"Name", "Value.filter"}),
        #"Expanded Value.set" = Table.ExpandListColumn(#"Removed Columns", "Value.set"),
        #"Renamed Columns" = Table.RenameColumns(#"Expanded Value.set",{{"Value.set", "Set"}}),
        #"Expanded Set" = Table.ExpandRecordColumn(#"Renamed Columns", "Set", {"recordID", "moduleID", "values", "namespaceID", "ownedBy", "createdAt", "createdBy"}, {"recordID", "moduleID", "values", "namespaceID", "ownedBy", "createdAt", "createdBy"}),
        #"Expanded values" = Table.ExpandListColumn(#"Expanded Set", "values"),
        #"Expanded values1" = Table.ExpandRecordColumn(#"Expanded values", "values", {"name", "value"}, {"name", "value"}),
        #"Pivoted Column" = Table.Pivot(#"Expanded values1", List.Distinct(#"Expanded values1"[name]), "name", "value")
    in
        #"Pivoted Column";

// Data Source Kind description
Corteza = [
    Authentication = [
        UsernamePassword = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

GetToken = (auth_url, user_id, secret) =>
    let
        Response = Web.Contents(auth_url, [
            Content = Text.ToBinary(Uri.BuildQueryString([
                grant_type = "client_credentials",
                scope = "api" 
               ])),
            Headers = [#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

GetData = (token, api_url, namespace, module) =>
    let
        fullUrl = if (module <> null) then api_url & "/compose/namespace/" & namespace & "/module/" & module & "/record/" else api_url & "/compose/namespace/" & namespace & "/module/",
        Response = Web.Contents(fullUrl, [
            Headers=[#"Accept" = "application/json,plain/text,*/*", #"Authorization" = "Bearer " & token]
        ]),
        Data = Json.Document(Response)
    in
        Data;
 
// Data Source UI publishing description
Corteza.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://www.cortezaproject.org/",
    SourceImage = Corteza.Icons,
    SourceTypeImage = Corteza.Icons
];

Corteza.Icons = [
    Icon16 = { Extension.Contents("Corteza16.png"), Extension.Contents("Corteza20.png"), Extension.Contents("Corteza24.png"), Extension.Contents("Corteza32.png") },
    Icon32 = { Extension.Contents("Corteza32.png"), Extension.Contents("Corteza40.png"), Extension.Contents("Corteza48.png"), Extension.Contents("Corteza64.png") }
];
