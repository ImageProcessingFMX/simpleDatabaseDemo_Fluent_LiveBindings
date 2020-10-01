program EVAL_fireDAC_fluent_liveBinding.FMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_FD.FMX_fluent_LB in 'Unit_FD.FMX_fluent_LB.pas' {Form_dbtest},
  LiveBindings.Fluent in 'LiveBindings.Fluent.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm_dbtest, Form_dbtest);
  Application.Run;
end.

