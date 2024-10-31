const getGoogleAuth = require("getGoogleAuth");
const sendHttpRequest = require("sendHttpRequest");
const JSON = require("JSON");
const log = require("logToConsole");

// Helper function
function transformObject(arr) {
    const result = [];
    for (let i = 0; i < arr.length; i++) {
        result.push([arr[i].key, arr[i].value]);
    }
    return result;
}

// Hardcoded values for testing
const spreadsheetId = data.sheet_id;  // Your sheet ID
const sheetName = data.sheet_name;  // Your sheet name
const sheetRange = data.sheet_range;  // Sheet name and range

// Build the URL
const url = "https://sheets.googleapis.com/v4/spreadsheets/" +
    spreadsheetId +
    "/values/" +
    sheetName +
    "!" +
    sheetRange +
    ":append?valueInputOption=RAW&includeValuesInResponse=true";

// Get Google auth once
const auth = getGoogleAuth({
    scopes: ["https://www.googleapis.com/auth/spreadsheets"]
});

if (data.dataTable) {
    log("Data Table: " + JSON.stringify(data.dataTable));

    const valuesToInsert = transformObject(data.dataTable);

    log("Values to insert: " + JSON.stringify(valuesToInsert));

    // The payload for Google Sheets.
    const postBodyData = {
        'values': valuesToInsert
    };
    const postBody = JSON.stringify(postBodyData);

    const postHeaders = {
        "Content-Type": "application/json"
    };
    const requestOptions = {
        headers: postHeaders,
        method: "POST",
        authorization: auth
    };

    // Make the request to Google Sheets & return the status code as the response.
    return sendHttpRequest(url, requestOptions, postBody)
        .then(successResult => {
            log("Status Code of the response: " + successResult.statusCode);
            if (successResult.statusCode >= 200 &&
                successResult.statusCode < 300) {
                log(JSON.stringify(successResult));
                data.gtmOnSuccess();
            }
            else {
                data.gtmOnFailure();
            }
        })
        .catch((error) => {
            log("Error with Google Sheets call to " + url + ". Error: ", error);
            data.gtmOnFailure();
        });
}

data.gtmOnFailure();