using System;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer), typeof(MeshFilter))]
public class InteractableVertice : MonoBehaviour
{
    private MarchingCubesMeshGenerator generator;
    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    public int Index;
    private bool isActive = false;

    private void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        meshFilter = GetComponent<MeshFilter>();

        meshRenderer.material.color = Color.black;
    }

    public void Initialize(MarchingCubesMeshGenerator _generator, int index)
    {
        generator = _generator;
        Index = index;
    }

    public void OnClick()
    {
        isActive = isActive == true ? false : true;

        meshRenderer.material.color = isActive == true
            ? Color.white 
            : Color.black;

        int cubeIndex = 0;

        switch (Index)
        {
            case 0: cubeIndex = 1; break;
            case 1: cubeIndex = 2; break;
            case 2: cubeIndex = 4; break;
            case 3: cubeIndex = 8; break;
            case 4: cubeIndex = 16; break;
            case 5: cubeIndex = 32; break;
            case 6: cubeIndex = 64; break;
            case 7: cubeIndex = 128; break;
        }

        generator.CalculateTriangulationNumber(isActive, cubeIndex);
    }
}
