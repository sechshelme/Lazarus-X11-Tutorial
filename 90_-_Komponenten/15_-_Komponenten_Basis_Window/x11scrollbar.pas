unit X11Scrollbar;

{$mode ObjFPC}{$H+}

interface

uses
  unixtype, ctypes, xlib, xutil, keysym, x,
  X11Utils, X11Panel, X11Component, X11Button;

type

  { TX11Button }

  { TX11ScrollBar }

  TX11ScrollBar = class(TX11Panel)
  private
    FMax, FMin: integer;
    FPosition: integer;
    FOnChange: TNotifyEvent;

    FrontButton, BackButton, FaceButton: TX11Button;
    FSmallChange: integer;
    procedure BackButtonClick(Sender: TObject);
    procedure FrontButtonClick(Sender: TObject);
    procedure SetFacePosition;
  protected
    procedure DoOnResize(AWidth, AHeight: cint); override;
  public
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Position: integer read FPosition write FPosition;
    property Min: integer read FMin write FMin;
    property Max: integer read FMax write FMax;
    property SmallChange: integer read FSmallChange write FSmallChange;
    constructor Create(TheOwner: TX11Component);
    destructor Destroy; override;
  end;

implementation

{ TX11ScrollBar }

procedure TX11ScrollBar.FrontButtonClick(Sender: TObject);
begin
  Dec(FPosition, FSmallChange);
  if FPosition < FMin then begin
    FPosition := FMin;
  end;
  if OnChange <> nil then begin
    OnChange(Self);
  end;
  SetFacePosition;
end;

procedure TX11ScrollBar.BackButtonClick(Sender: TObject);
begin
  Inc(FPosition, FSmallChange);
  if FPosition > FMax then begin
    FPosition := Max;
  end;
  if OnChange <> nil then begin
    OnChange(Self);
  end;
  SetFacePosition;
end;

procedure TX11ScrollBar.SetFacePosition;
var
  trackSrc, track: integer;
begin
  trackSrc := Width - FrontButton.Width - BackButton.Width - FaceButton.Width;
  track := FMax - FMin;
  FaceButton.Left := (FPosition - FMin) * trackSrc div track + FrontButton.Width;
end;

procedure TX11ScrollBar.DoOnResize(AWidth, AHeight: cint);
begin
  inherited DoOnResize(AWidth,AHeight);
  SetFacePosition;
end;

constructor TX11ScrollBar.Create(TheOwner: TX11Component);
begin
  inherited Create(TheOwner);
  IsFocusable := True;
  OnChange := nil;
  FPosition := 10;
  FSmallChange := 10;
  FMin := 0;
  FMax := 255;
  FPosition := 128;

  FrontButton := TX11Button.Create(Self);
  with FrontButton do begin
    Width := 25;
    Height := 25;
    Caption := '<';
    //    Anchors := [akTop, akRight];
    //    Anchors := [akLeft, akRight, akBottom];
    OnClick := @FrontButtonClick;
  end;

  BackButton := TX11Button.Create(Self);
  with BackButton do begin
    Width := 25;
    Height := 25;
    Left := Self.Width - 25;
    Caption := '>';
    //    Anchors := [akTop, akRight, akBottom];
    Anchors := [akTop, akRight];
    OnClick := @BackButtonClick;
  end;

  FaceButton := TX11Button.Create(Self);
  with FaceButton do begin
    Width := 25;
    Height := 25;
    //    Left:=50;
    Caption := 'O';
    //    Anchors := [akTop, akLeft, akBottom];
    Anchors := [akTop, akLeft];
    SetFacePosition;
  end;
end;

destructor TX11ScrollBar.Destroy;
begin
  inherited Destroy;
end;

end.