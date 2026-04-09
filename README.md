# CAFA 6 Protein Function Prediction: Multi-Modal Deep Learning Approach

This repository contains our solution for the [CAFA 6 (Critical Assessment of Functional Annotation) Competition](https://www.kaggle.com/competitions/cafa-6-protein-function-prediction). The objective is to predict Gene Ontology (GO) terms—spanning Molecular Function (MF), Biological Process (BP), and Cellular Component (CC)—directly from raw protein amino acid sequences.

## 🧬 Project Overview
Proteins dictate nearly every biological process, yet the functions of a vast majority of sequenced proteins remain unknown. This project leverages state-of-the-art Protein Language Models (pLMs) and sequence homology algorithms to accurately predict protein functions, aiding in the discovery of novel disease treatments and advancing systemic biology.

## 🧠 Methodology & Architecture

Our pipeline is a hybrid ensemble model combining deep representation learning with evolutionary sequence similarity:

1. **Deep Representation Learning (`ESM-2` Backbone)**
   - **Model:** Meta's `esm2_t33_650M_UR50D` (650 Million parameters).
   - **Process:** We extract 1280-dimensional contextual embeddings from the pre-trained transformer. These embeddings capture complex structural and evolutionary properties of the protein without requiring explicit 3D folding.
   - **Classification Head:** A customized 2-Layer Multi-Layer Perceptron (MLP) with ReLU activation and dropout, trained to map high-dimensional embeddings to thousands of concurrent GO terms using Multi-Label classification.

2. **Sequence Homology Signal (`DIAMOND`)**
   - We utilize DIAMOND/BLAST to perform rapid, local sequence alignment against a curated database of annotated proteins. 
   - This explicitly captures direct evolutionary lineage and acts as a robust fallback and ensembling signal.

3. **Weighted Ensembling**
   - Final probabilistic predictions are a weighted ensemble of the deep semantic predictions (ESM-2 + MLP) and the evolutionary homology predictions (DIAMOND). 

## ⚙️ Setup & Installation

**Prerequisites:** Python 3.9+, PyTorch (with CUDA support), and DIAMOND.

1. **Clone and setup the environment:**
   ```bash
   git clone <repo-url>
   cd <repo-name>
   create_env.bat
   pip install -r requirements.txt
   ```
2. **Download Data:**
   Ensure the Kaggle dataset is unzipped into `kaggle/input/cafa-6-protein-function-prediction/`.
3. **Run Pipeline:**
   Execute the `cafa-6.ipynb` Jupyter notebook to orchestrate data loading, embedding generation, MLP training, and final submission generation.

## 📊 Evaluation Metrics
The competition uses a custom Maximum F-measure metric based on weighted precision and recall. Weights are derived from the Information Accretion (IA) of each GO term within the ontology graph (rarer, deeper terms carry higher weights).

---
*Legacy instructions:*

Steps to create and use the environment (Windows):

- Create the venv and install packages:

```
call create_env.bat
```

- Activate the venv and add a Jupyter kernel pointing to it:

```
call .venv\Scripts\activate
python -m ipykernel install --user --name=cafa-env --display-name "Python (cafa-env)"
```

Then open `CAFA.ipynb` and select the kernel `Python (cafa-env)`.

Notes:

- `faiss` is not included due to limited Windows pip support; if you are on Linux you can install `faiss-cpu` for faster kNN.
- For GPU-enabled PyTorch, install the appropriate `torch` build from https://pytorch.org after creating the venv.
