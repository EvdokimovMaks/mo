.linkform 'td_mo' prototype is td_1_136
.nameinlist '��㤮��� ������� ��'
.group " td_1_136"
.var
  CATNAM: Z_STAFFCAT::CatalogsFunctions;
.endvar
.create view v_raise
as select *
from raise
where ((
  comp(NRecApp) == raise.appoint
));
.Fields
  if(v_raise.raise.sum <> 0, '- �������筠� ������ � ࠧ��� ', '- ')
  if(v_raise.raise.sum <> 0, integer(v_raise.raise.sum), '')
  if(v_raise.raise.sum <> 0, '% �� �������⭮�� ������ ', '')
  CATNAM.GetCatalogsName(v_raise.raise.raisetype)
.endFields
.begin
  if v_raise.getfirst raise = tsOk { };
end.
.{ Td_1_136_Cycle1 CheckEnter
.}

.{table 'v_raise.raise'
^^^^;
.}
.endform
