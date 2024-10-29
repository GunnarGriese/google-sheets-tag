## Google Sheets Tag for GTM Server-Side

This is a custom template for Google Tag Manager Server-Side that allows you to send data to Google Sheets. 

This template is based on the [Google Sheets API](https://developers.google.com/sheets/api). For authentication, it uses the [`getGoogleAuth`](https://developers.google.com/tag-platform/tag-manager/server-side/api#getgoogleauth) template API.

Using this API simplifies the authentication process (compared to previously built templates, like [Stape's](https://github.com/stape-io/spreadsheet-tag)) and allows you to use the Google Sheets API without having to worry about the authentication process.