.linkform 'SprMesR_mo' PROTOTYPE IS 'SprMesR'
.nameinlist'��ࠢ�� (��)'
.group 'SprMesR1'
.var
  af: Z_STAFF::AppointmentsFunctions;
.endvar

.create view v_podr
as select *
from appointments app, catalogs catDep
where ((
      af.GetAppNrec_OnDate(Persons_Nrec, cur_date) == app.nrec and
      app.department                               == catDep.nrec
));
.fields
  ������� ��� ����⢮
  v_podr.catDep.name
  ��⠐�������
  ���⮐�������
  ��ࠧ������
  ����稫��� ����稫��
  ���樠�쭮���
  �祭��⥯��� ������
  �����࠭�멟��

  ��⠑���諮� ��� ��⠏����諮�
  ��������삏�諮� �������������।�����諮�

  ��⠑�����६� ���1 ��⠏������६�
  ��������삍���६� �������������।��������

.endfields

.begin
  if v_podr.getfirst app = tsOk
    if v_podr.getfirst catDep = tsOk { }
end.

�������
^ ^ ^
�� ४��: ^
.{ CheckEnter CatalogsPost2
.}
��� ஦�����: ^
���� ஦�����: ^
��ࠧ������(����� � �� ����稫): ^ ^ ^
���樠�쭮��� �� ��ࠧ������: ^
���� �⥯���, ��񭮥 ������: ^ ^

.{ CheckEnter ContDoc
.}
.{ CheckEnter LangLanguageCat
������ �����࠭�묨 �몠�� �������: ^
.}
.{ CheckEnter OsvoenDrugProf
.}
.{ CheckEnter PovischenieKvalif
.}
.{ CheckEnter Experience
.{ CheckEnter Experience_Old
.}
.{ CheckEnter Experience_Rename
.}
.}
.{ CheckEnter Appointments
.{ CheckEnter Appointments_Old
.}
.{ CheckEnter Appointments_Rename
.}
.}
.{ CheckEnter PsnLinks
.}
.endform

