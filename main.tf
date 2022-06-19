resource "aws_instance" "vms" {
  # Количество создаваемых виртуальных машин берём из переменной vms_count
  count = 1
  # ID образа для создания экземпляра ВМ – из переменной vm_template
  ami = "cmi-3CF790E9"
  # Наименование типа экземпляра создаваемой ВМ – из переменной vm_instance_type
  instance_type = "MyVM"
  # Добавляем на сервер публичный SSH-ключ, созданный ранее
  key_name = var.pubkey_name
  # Не выделяем и не присваиваем экземпляру внешний Elastic IP
  associate_public_ip_address = false
  # Активируем мониторинг экземпляра
  monitoring = true

  # Экземпляр создаём только после того как созданы:
  # – публичный SSH-ключ
  depends_on = [
    aws_key_pair.pubkey,
  ]

  tags = {
    Name = "VM for Test Terraform"
  }

  # Создаём диск, подключаемый к экземпляру
  ebs_block_device {
    # Говорим удалять диск вместе с экземпляром
    delete_on_termination = true
    # Задаём имя устройства вида "disk<N>",
    device_name = "disk1"
    # его тип
    volume_type = "st2"
    # и размер
    volume_size = 32

    tags = {
      Name = "Disk for VM test Terraform"
    }
  }
}