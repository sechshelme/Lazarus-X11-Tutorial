unit X11Component;

{$mode ObjFPC}{$H+}

interface

uses
  unixtype, ctypes, xlib, xutil, keysym, x;

type

  TNotifyEvent = procedure(Sender: TObject) of object;
  TMouseMoveEvent = procedure(Sender: TObject; X, Y: integer) of object;
  { TX11Component }

  TX11Component = class(TObject)
  private
    FCaption: string;
    FColor: culong;
    FHeight, FLeft, FTop, FWidth: cint;
    FOnMouseMove: TMouseMoveEvent;
    FName: string;
    FParent: TX11Component;
    ComponentList: array of TX11Component;
    FOnClick: TNotifyEvent;
    procedure SetTop(ATop: cint);
    procedure SetLeft(ALeft: cint);
  protected
    IsMouseDown, IsButtonDown: boolean;
    Region: TRegion;
    procedure DoOnEventHandle(var Event: TXEvent); virtual;
    procedure DoOnPaint; virtual;
    procedure DoOnResize(AWidth, AHeight: cint); virtual;
  public
    dis: PDisplay;
    win: TDrawable;
    gc: TGC;
    LastWindowWidth, LastWindowHeight: cint;
    Anchors: set of (akTop, akLeft, akRight, akBottom);
    property Name: string read FName write FName;
    property Parent: TX11Component read FParent write FParent;
    property Caption: string read FCaption write FCaption;
    property Color: culong read FColor write FColor;
    property Left: cint read FLeft write SetLeft;
    property Top: cint read FTop write SetTop;
    property Width: cint read FWidth write FWidth;
    property Height: cint read FHeight write FHeight;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    constructor Create(TheOwner: TX11Component);
    destructor Destroy; override;
  end;

implementation

{ TX11Component }

procedure TX11Component.SetTop(ATop: cint);
begin
  if Parent = nil then begin
    FTop := ATop;
  end else begin
    FTop := Parent.FTop + ATop;
  end;
end;

procedure TX11Component.SetLeft(ALeft: cint);
begin
  if Parent = nil then begin
    FLeft := ALeft;
  end else begin
    FLeft := Parent.FLeft + ALeft;
  end;
end;

constructor TX11Component.Create(TheOwner: TX11Component);
var
  s: string;
begin
  FParent := TheOwner;
  OnClick := nil;
  OnMouseMove := nil;

  Anchors := [akTop, akLeft];
  Color := $BBBBBB;
  Left := 0;
  Top := 0;
  Width := 320;
  Height := 200;
  LastWindowWidth := Width;
  LastWindowHeight := Height;

  Region := XCreateRegion;
  Name := 'X11Component';

  if TheOwner <> nil then begin
    SetLength(TheOwner.ComponentList, Length(TheOwner.ComponentList) + 1);
    TheOwner.ComponentList[Length(TheOwner.ComponentList) - 1] := Self;
    dis := TheOwner.dis;
    win := TheOwner.win;
    gc := TheOwner.gc;
    str(Length(TheOwner.ComponentList), s);
    FName += s;
  end;
end;

destructor TX11Component.Destroy;
begin
  XDestroyRegion(Region);
  inherited Destroy;
end;

procedure TX11Component.DoOnEventHandle(var Event: TXEvent);
var
  i: integer;
  x, y: cint;
  IsInRegion: TBoolResult;
begin
  for i := 0 to Length(ComponentList) - 1 do begin
    ComponentList[i].DoOnEventHandle(Event);
  end;

  x := Event.xbutton.x;
  y := Event.xbutton.y;
  IsInRegion := XPointInRegion(Region, x, y);
  case Event._type of
    Expose: begin
      DoOnPaint;
    end;
    ConfigureNotify: begin
      DoOnResize(Event.xconfigure.Width, Event.xconfigure.Height);
      LastWindowWidth := Event.xconfigure.Width;
      LastWindowHeight := Event.xconfigure.Height;
    end;
    KeyPress: begin
      if XLookupKeysym(@Event.xkey, 0) = XK_Escape then begin
        // Taste auswerten
      end;
    end;
    ButtonPress: begin
      if IsInRegion then begin
        IsMouseDown := True;
        IsButtonDown := True;
      end else begin
        IsMouseDown := False;
        IsButtonDown := False;
      end;
      DoOnPaint;
    end;
    MotionNotify: begin
      if IsInRegion and (OnMouseMove <> nil) then begin
        OnMouseMove(self, x, y);
      end;
      if IsMouseDown then begin
        if IsInRegion then begin
          //   if not IsButtonDown then DoOnPaint;
          IsButtonDown := True;
        end else begin
          //    if IsButtonDown then DoOnPaint;
          IsButtonDown := False;
        end;
        DoOnPaint;
      end;
    end;
    ButtonRelease: begin
      if IsMouseDown and IsInRegion then begin
        if OnClick <> nil then begin
          OnClick(self);
        end;
      end;
      IsMouseDown := False;
      IsButtonDown := False;
      DoOnPaint;
    end;
  end;
end;

procedure TX11Component.DoOnPaint;
var
  i: integer;
begin
  XSetRegion(dis, gc, Region);
  XSetForeground(dis, gc, Color);
  XFillRectangle(dis, win, gc, Left, Top, Width, Height);
  for i := 0 to Length(ComponentList) - 1 do begin
    ComponentList[i].DoOnPaint;
  end;
  XSetRegion(dis, gc, Region);
end;

procedure TX11Component.DoOnResize(AWidth, AHeight: cint);
var
  rect: TXRectangle;
  d: cint;
  mody: boolean;
begin
  mody := False;

  //  if LastWindowWidth <> AWidth then begin
  mody := True;
  d := AWidth - LastWindowWidth;
  if akRight in Anchors then begin
    if akLeft in Anchors then begin
      FWidth := FWidth + d;
    end else begin
      FLeft := FLeft + d;
    end;
  end;
  //  end;

  //  if LastWindowHeight <> AHeight then begin
  mody := True;
  d := AHeight - LastWindowHeight;
  if akBottom in Anchors then begin
    if akTop in Anchors then begin
      FHeight := FHeight + d;
    end else begin
      FTop := FTop + d;
    end;
  end;
  //  end;

  if mody then begin
    rect.x := FLeft;
    rect.y := FTop;
    rect.Width := FWidth;
    rect.Height := FHeight;

    if XEmptyRegion(Region) = 0 then begin
      XDestroyRegion(Region);
    end;
    Region := XCreateRegion;
    XUnionRectWithRegion(@rect, Region, Region);

    if (Parent <> nil) and (XEmptyRegion(Parent.Region) = 0) then begin
      XIntersectRegion(Region, Parent.Region, Region);
    end;

    DoOnPaint;
  end;
end;

end.
