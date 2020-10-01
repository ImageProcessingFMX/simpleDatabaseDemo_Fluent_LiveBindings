unit Unit_FD.FMX_fluent_LB;

interface

uses
  LiveBindings.Fluent,
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Unit_dbfunctions,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, System.IOUtils,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.ScrollBox,
  FMX.Grid, FMX.Layouts, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.Controls, FMX.Bind.Navigator;

type
  TForm_dbtest = class(TForm)
    edt_server: TEdit;
    edt_databasename: TEdit;
    pnl1: TPanel;
    statusbar: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    btn_ConnectDatabase: TButton;
    con1: TFDConnection;
    btn_getOBJTable: TButton;
    lst_servernames: TListBox;
    lst_Databases: TListBox;
    lbl3: TLabel;
    edt_tablename: TEdit;
    lst_databasetablelist: TListBox;
    btn_Connect2Server: TButton;
    btn_LoadServerNames: TButton;
    dlgOpenFile: TOpenDialog;
    lbl4: TLabel;
    btn1: TButton;
    pnl2: TPanel;
    strngrd1: TStringGrid;
    bndnvgtr1: TBindNavigator;
    pnl3: TPanel;
    edt_field: TEdit;
    btn2: TButton;
    procedure btn_ConnectDatabaseClick(Sender: TObject);
    procedure btn_getOBJTableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lst_servernamesDblClick(Sender: TObject);
    procedure btn_Connect2ServerClick(Sender: TObject);
    procedure lst_DatabasesDblClick(Sender: TObject);
    procedure lst_databasetablelistDblClick(Sender: TObject);
    procedure btn_LoadServerNamesClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Fservername: String;
    Fdatabasename: String;
    Fusername: String;
    FPassword: String;
    FTablename: string;

    Fpath: TPath;
    FDQuery1: TFDQuery;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;

    procedure GUI2Params(Sender: TObject);
    procedure LoadServerNames2Listbox(filename: string);
  public
    { Public declarations }
  end;

var
  Form_dbtest: TForm_dbtest;

implementation

{$R *.fmx}

procedure TForm_dbtest.btn1Click(Sender: TObject);
var
  Databasename, User, Password: string;
begin
  /// http://docwiki.embarcadero.com/Libraries/Sydney/en/FireDAC.Phys.MSSQL.TFDPhysMSSQLDriverLink
  ///
  ///
  Databasename := 'testdb03';

  // User:='testuser';
  // Password :='testuser';

  User := 'root';
  Password := '';

  // ConnecttoServerMYSQL (con1, Fservername, Databasename, User, Password );
end;

procedure TForm_dbtest.btn2Click(Sender: TObject);
var  QueryfieldName : String ;
     FieldCount : Integer ;
begin

  FieldCount := FDQuery1.DataSource.DataSet.FieldCount;

  QueryfieldName := FDQuery1.DataSource.DataSet.FieldList.Fields[1]
    .FieldName ;

  BindingsList1.BindComponent(edt_field)
    .ToField(BindSourceDB1, QueryfieldName );
end;

procedure TForm_dbtest.btn_Connect2ServerClick(Sender: TObject);
var
  FDatabaseList: TStringList;
begin
  GUI2Params(nil);

  ConnecttoServer(con1, Fservername);

  statusbar.text := ' Connect to a server ..... ';

  FDatabaseList := TStringList.Create;
  try
    GetAllDatabases(Fservername, FDatabaseList);

    lst_Databases.Items.Clear;

    lst_Databases.Items.AddStrings(FDatabaseList);
  finally
    FDatabaseList.Free;
  end;

  statusbar.text := ' double click a database name and press [3] ';

end;

procedure TForm_dbtest.btn_ConnectDatabaseClick(Sender: TObject);
var
  FTableList: TStringList;
begin
  GUI2Params(nil);

  ConnecttoDatabase(Fservername, Fdatabasename, con1);

  statusbar.text := ' Connect to a database ..... ';

  FTableList := TStringList.Create;
  try
    GetAllTables(con1, Fdatabasename, FTableList);

    lst_databasetablelist.Items.Clear;

    lst_databasetablelist.Items.AddStrings(FTableList);
  finally
    FTableList.Free;
  end;

  statusbar.text := ' double click a datbase table name and press [4] ';
end;

procedure TForm_dbtest.btn_getOBJTableClick(Sender: TObject);
var
  conStatus: Boolean;
begin


  BindingsList1.BindGrid(strngrd1).DefaultColumnWidth(256)
    .ToBindSource(BindSourceDB1);

  try

    FTablename := edt_tablename.text;

    conStatus := con1.Connected;

    FDQuery1.SQL.Clear;

    if conStatus = TRUE then
    begin
      FDQuery1.SQL.Add('select * from ' + FTablename);

      FDQuery1.Active := TRUE;
    end
    else
    begin
      ShowMessage('No DB Connection established.');
    end;

  finally;
    statusbar.text := ' done :-)   using ' + FTablename;
  end;

end;

procedure TForm_dbtest.LoadServerNames2Listbox(filename: string);
var
  SQLServerfilenames: TStringList;
begin
  SQLServerfilenames := TStringList.Create;

  try
    SQLServerfilenames.Loadfromfile(filename);

    lst_servernames.Items.Clear;

    lst_servernames.Items.AddStrings(SQLServerfilenames);

  finally
    SQLServerfilenames.Free;
  end;

end;

procedure TForm_dbtest.btn_LoadServerNamesClick(Sender: TObject);
var
  SQLServerfilename: TStringList;
begin
  if dlgOpenFile.Execute then
  begin
    statusbar.text :=
      ' Load a text file with all server names in your net work ! ';

    LoadServerNames2Listbox(dlgOpenFile.filename);

  end;

  statusbar.text := ' double click a server name and press [2] ';
end;

procedure TForm_dbtest.FormCreate(Sender: TObject);
begin
  FDQuery1 := TFDQuery.Create(self);
  FDQuery1.Connection := con1;

  BindSourceDB1 := TBindSourceDB.Create(self);
  BindSourceDB1.DataSet := FDQuery1;

  BindingsList1 := TBindingsList.Create(self);
end;

procedure TForm_dbtest.FormShow(Sender: TObject);
begin
  statusbar.text := ' Connect to da database uning FIREDAC & MSSQL';
end;

procedure TForm_dbtest.GUI2Params(Sender: TObject);
begin
  Fservername := edt_server.text;

  Fdatabasename := edt_databasename.text;
end;

procedure TForm_dbtest.lst_databasetablelistDblClick(Sender: TObject);
begin
  edt_tablename.text := lst_databasetablelist.Items
    [lst_databasetablelist.ItemIndex];
end;

procedure TForm_dbtest.lst_DatabasesDblClick(Sender: TObject);
begin
  edt_databasename.text := lst_Databases.Items[lst_Databases.ItemIndex];
end;

procedure TForm_dbtest.lst_servernamesDblClick(Sender: TObject);
begin
  edt_server.text := lst_servernames.Items[lst_servernames.ItemIndex];
end;

end.
