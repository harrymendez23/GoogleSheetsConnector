global without sharing class GoogleSheetsDatasourceConnection extends DataSource.Connection {

    private String spreadsheetId { get; set; }
    private GoogleSheetsService gService;
    public GoogleSheetsDatasourceConnection(DataSource.ConnectionParams connectionParams) {
        spreadsheetId = '1_NT5ClxAxvEnXqRSWAoIMmLa8grMVV1KnI3pxunV0cY'; //TODO: remove hardcoded Id
        gService = new GoogleSheetsService(SpreadSheetId);
    }

    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();
        List<String> sheets = gService.getSheets();
        for(String sheet : sheets)
        {
            List<String> colHeaders = gService.getSheetHeader(sheet);
            List<DataSource.Column> columns = new List<DataSource.Column>();
            String nameCol = '';
            for (Integer i = 0; i < colHeaders.size(); i++)
            {
                if (i == 0) { //first column
                    nameCol = colHeaders[i];
                }

                columns.add(DataSource.Column.text(colHeaders[i], 255));
            }
            
            tables.add(DataSource.Table.get(sheet, nameCol, columns));
        }
        
        return tables;
    }
}
