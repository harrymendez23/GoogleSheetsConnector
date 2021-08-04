public without sharing class GoogleSheetsService {
    private final String URL_TEMPLATE = 'callout:GoogleSheetsAPI/v4/spreadsheets/';
    public String SpreadSheetId{ get; set; }
    public GoogleSheetsService(String p_spreadSheet) {
        this.SpreadSheetId = p_spreadSheet;
    }


    public List<String> getSheets() {
        List<String> result = new List<String>();
        String spreadsheetGet = URL_TEMPLATE + SpreadSheetId;


        HttpResponse response = sendRequest(spreadsheetGet, 'GET', 'application/json', 'application/json');
        Map<String, Object> objectsByKeys = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        List<Object> sheets =  (List<Object>) objectsByKeys.get('sheets');
        Map<String, Object> sheet1 = (Map<String, Object>) sheets[0];
        
        for (Object obj : sheets)
        {
            Map<String, Object> sheet = (Map<String, Object>) obj;
            Map<String, Object> properties = (Map<String, Object>) sheet.get('properties');
            result.add((String) properties.get('title'));
        }

        return result;
    }


    public List<String> getSheetHeader(String sheet) {
        List<String> result = new List<String>();
        List<Object> values = getSheetValues(sheet);
        List<Object> header = (List<Object>) values[0];
        for (Object col : header) {
            result.add((String) col);
        }

        return result;
    }


    public List<Object> getSheetValues(String sheet) {
        List<Object>  result;

        try {
            HttpResponse response =
                sendRequest(URL_TEMPLATE + SpreadSheetId + '/values/' + sheet, 'GET', 'application/json', 'application/json');
            
            Map<String, Object> valueRange = (Map<String, Object>)  JSON.deserializeUntyped(response.getBody());
            List<Object> values = (List<Object>) valueRange.get('values');
            result = values;
            System.debug('values: ' + values);
        } catch (Exception e) {
            System.debug('ERROR: ' + e);
        }

        return result;
    }


    public HttpResponse sendRequest(String URI, String method, String accept, String contentType) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URI);
        req.setHeader('Accept', accept);
        req.setHeader('Content-Type', contentType);
        req.setMethod(method);

        return new Http().send(req);
    }
    
}
