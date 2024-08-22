import sagemaker
from sagemaker.pytorch import PyTorch

# Sessão do SageMaker
sagemaker_session = sagemaker.Session()

# Localização do bucket S3
bucket = 'train-bucket-udi-meetup'
prefix = 'sagemaker/pytorch-gpt2'

# Localização do script de treinamento no S3
#script_path = f's3://{bucket}/scripts/train.py'
#script_path = f's3://train-bucket-udi-meetup/scripts/train.py'
script_path = 'C:/dev/aws-meetup/scripts/train.py'

# Configuração do job de treinamento
estimator = PyTorch(
    entry_point=script_path,
    role='arn:aws:iam::147397866377:role/SageMakerRole',  # Substitua pelo seu ARN de IAM role
    framework_version='1.12.1',
    py_version='py38',
    instance_count=1,
    instance_type='ml.p3.2xlarge',  # Instância com GPU para acelerar o treinamento
    output_path=f's3://train-bucket-udi-meetup/{prefix}/output',
    hyperparameters={
        'epochs': 3,
        'train_batch_size': 4,
    },
    sagemaker_session=sagemaker_session,
    dependencies=['C:/dev/aws-meetup/scripts/requirements.txt']
)

# Iniciar o treinamento
estimator.fit({'train': 's3://train-bucket-udi-meetup/train.csv'})
