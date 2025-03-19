___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Write to Google Sheets (V2)",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "A tag that let\u0027s you write a list of values to your Google Sheet of choice.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "sheet_id",
    "displayName": "Sheet ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "TEXT",
    "name": "sheet_name",
    "displayName": "Sheet Name",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "TEXT",
    "name": "sheet_range",
    "displayName": "Sheet Range",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "dataTable",
    "displayName": "Data to Insert",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true,
    "help": "The values below will be appended to the specified Google Sheet as a new row."
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getGoogleAuth = require("getGoogleAuth");
const sendHttpRequest = require("sendHttpRequest");
const JSON = require("JSON");
const log = require("logToConsole");

// Helper function
function transformObjectDynamic(arr, keyProp, valueProp) {
    const result = [];
    for (let i = 0; i < arr.length; i++) {
        result.push([arr[i][keyProp], arr[i][valueProp]]);
    }
    return result;
}

function getCellData() {
    let mappedData = [];

    if (data.dataTable) {
        data.dataTable.forEach(dataEntry => {
            mappedData.push(dataEntry.value);
        });
    }

    return {
        'values': [mappedData],
    };
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


    // The payload for Google Sheets.
    const postBodyData = getCellData();
  
    const postBody = JSON.stringify(postBodyData);
    log("Values to insert: " + postBody);

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


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "use_google_credentials",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedScopes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://www.googleapis.com/auth/spreadsheets"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 29/10/2024, 12:13:23


