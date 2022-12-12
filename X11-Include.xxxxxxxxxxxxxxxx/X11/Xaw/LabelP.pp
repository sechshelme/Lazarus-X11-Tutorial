
unit LabelP;
interface

{
  Automatically converted by H2Pas 1.0.0 from /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/LabelP.h
  The following command line parameters were used:
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/LabelP.h
    -p
    -T
    -S
    -d
    -c
    -o
    /n4800/DATEN/Programmierung/mit_GIT/Lazarus/Tutorial/X11/X11-Include/X11/Xaw/LabelP.pp
}

{ Pointers to basic pascal types, inserted by h2pas conversion program.}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;

Type
Pchar  = ^char;
PLabelClassPart  = ^LabelClassPart;
PLabelClassRec  = ^LabelClassRec;
PLabelPart  = ^LabelPart;
PLabelRec  = ^LabelRec;
PXFontStruct  = ^XFontStruct;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}



{$ifndef _XawLabelP_h}
{$define _XawLabelP_h}

{$include <X11/Xaw/Label.h>}
{$include <X11/Xaw/SimpleP.h>}

type
  PLabelClassPart = ^TLabelClassPart;
  TLabelClassPart = record
      extension : TXtPointer;
    end;


  PLabelClassRec = ^TLabelClassRec;
  TLabelClassRec = record
      core_class : TCoreClassPart;
      simple_class : TSimpleClassPart;
      label_class : TLabelClassPart;
    end;
  var
    labelClassRec : TLabelClassRec;cvar;external;





{$ifndef OLDXAW}

{$endif}
type
  PLabelPart = ^TLabelPart;
  TLabelPart = record
      foreground : TPixel;
      font : PXFontStruct;
      fontset : TXFontSet;
      _label : Pchar;
      justify : TXtJustify;
      internal_width : TDimension;
      internal_height : TDimension;
      pixmap : TPixmap;
      resize : TBoolean;
      encoding : byte;
      left_bitmap : TPixmap;
      normal_GC : TGC;
      gray_GC : TGC;
      stipple : TPixmap;
      label_x : TPosition;
      label_y : TPosition;
      label_width : TDimension;
      label_height : TDimension;
      label_len : TDimension;
      lbm_y : longint;
      lbm_width : dword;
      lbm_height : dword;
      pad : array[0..3] of TXtPointer;
    end;


  PLabelRec = ^TLabelRec;
  TLabelRec = record
      core : TCorePart;
      simple : TSimplePart;
      _label : TLabelPart;
    end;

function LEFT_OFFSET(lw : longint) : longint;

{$endif}


implementation

function LEFT_OFFSET(lw : longint) : longint;
var
   if_local1 : longint;
(* result types are not known *)
begin
  if lw^.(_label.left_bitmap) then
    if_local1:=(lw^.(_label.lbm_width))+(lw^.(_label.internal_width))
  else
    if_local1:=0;
  LEFT_OFFSET:=if_local1;
end;


end.
