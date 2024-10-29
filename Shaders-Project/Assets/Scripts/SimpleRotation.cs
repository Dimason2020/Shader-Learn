using UnityEngine;

namespace Utilities
{
    public class SimpleRotation : MonoBehaviour
    {
        [SerializeField] private Vector3 rotationSpeed;

        private Vector3 rotation;

        private void Awake() => rotation = transform.rotation.eulerAngles;

        private void Update()
        {
            rotation += rotationSpeed * Time.deltaTime;
            transform.rotation = Quaternion.Euler(rotation);
        }
    }
}