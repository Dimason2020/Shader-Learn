using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseMap : MonoBehaviour
{
    [SerializeField] private Material material;
    [SerializeField] private Vector3 distance;
    private Vector3 startPosition;
    Vector2 textureOffset = Vector2.zero;

    private void Start()
    {
        startPosition = transform.position;
    }

    private void Update()
    {
        distance = (transform.position - startPosition) / 10;
        textureOffset.x = distance.x;
        textureOffset.y = distance.z;
        material.SetTextureOffset("_HeightMap", -textureOffset);
    }
}
