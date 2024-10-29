using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParallelepipedGenerator : MonoBehaviour
{
    [SerializeField]
    private int xSize, ySize, zSize;

    private Vector3[] verticies;
    private Mesh mesh;
}
