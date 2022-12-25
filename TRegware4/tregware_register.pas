unit tregware_register;

interface

uses classes, regware4, reggen4;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WAK', [TRegware4, TRegCodeGenerator4]);
end;

end.
