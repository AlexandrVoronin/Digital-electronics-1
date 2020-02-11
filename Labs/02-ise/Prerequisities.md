## Lab prerequisites

1. *Digital* or *Binary comparator* compares the digital signals A, B presented at input terminal and produce outputs depending upon the condition of those inputs. Complete a truth table for 1-bit *Identity comparator* (A=B), and two *Magnitude comparators* (A>B, A<B). Note 1 represents true, 0 false.

    | **A** | **B** | **A>B** | **A=B** | **A<B** |
    | :-: | :-: | :-: | :-: | :-: |
    | 0 | 0 | 0 | 1 | 0 |
    | 0 | 1 | 0 | 0 | 1 |
    | 1 | 0 | 1 | 0 | 0 |
    | 1 | 1 | 0 | 1 | 0 |

    According to the truth table, create canonical SoP (Sum of Product) or PoS (Product of Sum) output forms as follows:
    Create K-maps for all three functions.
    
    &nbsp;

    ![equation](https://latex.codecogs.com/gif.latex?y_%7BA%3EB%7D%5E%7BSoP%7D%3D) ![equation](https://latex.codecogs.com/gif.latex?A%5Ccdot%20%5Cbar%7BB%7D)
    | **A: v B: ->** | 0 | 1 |
    | :-: | :-: | :-: |
    | 0 | 0 | 0 |
    | 1 | 1 | 0 |
    
    &nbsp;
    
    ![equation](https://latex.codecogs.com/gif.latex?y_%7BA%3DB%7D%5E%7BSoP%7D%3D) ![equation](https://latex.codecogs.com/gif.latex?%28%5Cbar%7BA%7D%5Ccdot%20%5Cbar%7BB%7D%29%20&plus;%20%28A%20%5Ccdot%20B%29)   
    | **A: v B: ->** | 0 | 1 |
    | :-: | :-: | :-: |
    | 0 | 0 | 1 |
    | 1 | 1 | 0 |
    
    &nbsp;
    
    ![equation](https://latex.codecogs.com/gif.latex?y_%7BA%3CB%7D%5E%7BPoS%7D%3D) ![equation](https://latex.codecogs.com/gif.latex?%28%5Cbar%7BA%7D%20&plus;%20%5Cbar%7BB%7D%29%20%5Ccdot%20%28A%20&plus;%20B%29%5Ccdot%20%28%5Cbar%7BA%7D%20&plus;%20B%29) 
    | **A: v B: ->** | 0 | 1 |
    | :-: | :-: | :-: |
    | 0 | 0 | 1 |
    | 1 | 0 | 0 |
    
    &nbsp;

    Create K-maps for all three functions.
    

    Use the K-map to create the minimum ![equation](https://latex.codecogs.com/gif.latex?y_%7BA%3CB%7D%5E%7BPoS%2Cmin%7D) function.

    &nbsp;
