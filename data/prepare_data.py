import torch
from torch.utils.data import DataLoader, TensorDataset

def get_dataloaders():
    x = torch.randn(100, 10)
    y = torch.randn(100, 1)
    dataset = TensorDataset(x, y)
    train_loader = DataLoader(dataset, batch_size=10)
    val_loader = DataLoader(dataset, batch_size=10)
    return train_loader, val_loader