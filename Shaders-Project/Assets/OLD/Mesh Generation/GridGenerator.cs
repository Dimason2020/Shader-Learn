using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class GridGenerator : MonoBehaviour
{
    [SerializeField] private int xSize, ySize;

    private MeshRenderer meshRenderer;
    private MeshFilter meshFilter;
    private Mesh mesh;
    private Vector3[] verticies;


    private void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        meshFilter = GetComponent<MeshFilter>();
        Generate();
    }

    private void Generate()
    {
        mesh = new Mesh();
        meshFilter.mesh = mesh;
        mesh.name = "Grid";

        verticies = new Vector3[(xSize + 1) * (ySize + 1)];
        Vector2[] uvs = new Vector2[verticies.Length];
        Vector4[] tangents = new Vector4[verticies.Length];
        Vector4 tangent = new Vector4(1f, 0f, 0f, -1f);

        for (int i = 0, y = 0; y <= ySize; y++)
        {
            for (int x = 0; x <= xSize; x++, i++)
            {
                verticies[i] = new Vector3(x, y);
                uvs[i] = new Vector2((float)x / xSize, (float)y / ySize);
                tangents[i] = tangent;
            }
        }
        mesh.vertices = verticies;
        mesh.uv = uvs;
        mesh.tangents = tangents;

        int[] triangles = new int[xSize * ySize * 6];
        for (int ti = 0, vi = 0, y = 0; y < ySize; y++, vi++)
        {
            for (int x = 0; x < xSize; x++, ti += 6, vi++)
            {
                triangles[ti] = vi;
                triangles[ti + 1] = triangles[ti + 4] = vi + xSize + 1;
                triangles[ti + 2] = triangles[ti + 3] = vi + 1;
                triangles[ti + 5] = vi + xSize + 2;
            }
        }

        mesh.triangles = triangles;
        mesh.RecalculateNormals();
    }

    private void OnDrawGizmos()
    {
        if (verticies == null) return;

        Gizmos.color = Color.red;

        for (int i = 0; i < verticies.Length; i++)
        {
            Gizmos.DrawSphere(verticies[i], 0.15f);
        }
    }
}
