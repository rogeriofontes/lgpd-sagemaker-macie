import os
import torch
from datasets import load_dataset
from transformers import GPT2LMHeadModel, GPT2Tokenizer, Trainer, TrainingArguments

def main():
    # Carregar os dados de treinamento
    dataset = load_dataset('csv', data_files={'train': 's3://train-bucket-udi-meetup/train.csv'})['train']

    # Inicializar o modelo e o tokenizer
    model_name = "gpt2"
    tokenizer = GPT2Tokenizer.from_pretrained(model_name)
    model = GPT2LMHeadModel.from_pretrained(model_name)

    # Resolver o problema de pad_token
    tokenizer.pad_token = tokenizer.eos_token

    # Tokenizar os dados
    def tokenize_function(examples):
        inputs = tokenizer(examples['prompt'], padding="max_length", truncation=True)
        inputs["labels"] = inputs["input_ids"].copy()
        return inputs

    tokenized_dataset = dataset.map(tokenize_function, batched=True)

    # Configurar os parâmetros de treinamento
    training_args = TrainingArguments(
        output_dir="/opt/ml/model",
        per_device_train_batch_size=4,
        num_train_epochs=3,
        logging_dir="/opt/ml/logs",
        logging_steps=10,
    )

    # Configurar o trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized_dataset,
    )

    # Treinar o modelo
    trainer.train()

    # Salvar o modelo treinado e o tokenizer
    model.save_pretrained("/opt/ml/model")
    tokenizer.save_pretrained("/opt/ml/model")

if __name__ == "__main__":
    main()
