unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  TCallerID = procedure(const DeviceSerial: PWideChar; const Line: PWideChar;
    const PhoneNumber: PWideChar; const DateTime: PWideChar; const Other: PWideChar);
  stdcall;

  TSignal = procedure(const DeviceModel: PWideChar; const DeviceSerial: PWideChar;
    const Signal1: Integer; const Signal2: Integer;
    const Signal3: Integer; const Signal4: Integer); stdcall;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  cidshow_lib = 'cidshow_x86\cid.dll';

var
  Form1: TForm1;
  say: integer = 0;

implementation

{$R *.dfm}

procedure SetEvents(CallerIDEvent: TCallerID; SignalEvent: TSignal); stdcall;
  external cidshow_lib;

procedure CallerID(const DeviceSerial: PWideChar; const Line: PWideChar;
  const PhoneNumber: PWideChar; const DateTime: PWideChar; const Other: PWideChar); stdcall;
begin
  say := say + 1;
  Form1.Memo1.Lines.Add(inttostr(say) + #9 + ' Caller id: ' + PhoneNumber + '    Line : ' + Line +
    '     DateTime: '
    + DateTime + '    DeviceSerial: ' + DeviceSerial + '   ' + Other);

end;

procedure Signal(const DeviceModel: PWideChar; const DeviceSerial: PWideChar;
  const Signal1: Integer; const Signal2: Integer;
  const Signal3: Integer; const Signal4: Integer); stdcall;

var
  s: string;
begin

  s := DeviceModel;

  if length(s) < 3 then
    s := 'No Connection'
  else
    s := 'Device: '+s + ' - ' + DeviceSerial;

  Form1.Label1.Caption := s;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Label1.Caption := '';
  memo1.Clear;
  SetEvents(CallerID, Signal);
end;

end.
