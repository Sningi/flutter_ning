roster{     //������
    dateId varchar(9) ,//ʱ��+�ڴ�  201902109
    classId int ,    //�༶
    courseName varchar(20), //�γ���
    sum     int ,    //����
    should   int,    //Ӧ��
    already int     //�ѵ�
    absence text    //ȱ������
    leave   text    //�������
}

classroom{
    id int  primary key autoincrement , //�༶id  ��������
    name varchar(15) ,//�༶���� 
    site varchar(15) ,//�༶λ��
    sum int ,//������
}

student{
    id int primary key autoincrement ,  //��������
    seatid varchar(15) ,              //ѧ��
    name varchar(10) ,                   //����cc
    sex int ,                            //�Ա�
    classId int 
    foreign key(classId) references classroom(id) on delete cascade
}