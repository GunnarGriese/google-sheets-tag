___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Write to Google Sheets",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "A tag that let\u0027s you write a key-value pair to your Google Sheet of choice.",
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
        "displayName": "Key",
        "name": "column1",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "column2",
        "type": "TEXT"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  }
]


___SANDBOXED_JS_FOR_SERVER___

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


