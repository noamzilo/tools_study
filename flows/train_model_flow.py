from metaflow import FlowSpec, step
from models.lightning_module import LitModel
from lightning.pytorch import Trainer
from data.prepare_data import get_dataloaders

class TrainModelFlow(FlowSpec):

    @step
    def start(self):
        self.train_dl, self.val_dl = get_dataloaders()
        self.next(self.train)

    @step
    def train(self):
        model = LitModel()
        trainer = Trainer(max_epochs=3, accelerator="cpu")
        trainer.fit(model, self.train_dl, self.val_dl)
        self.model_path = "model.ckpt"
        trainer.save_checkpoint(self.model_path)
        self.next(self.end)

    @step
    def end(self):
        print("Training completed. Model saved at:", self.model_path)

if __name__ == "__main__":
    TrainModelFlow()