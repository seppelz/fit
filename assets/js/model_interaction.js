// Function to highlight a muscle group
function highlightMuscleGroup(meshName, color) {
  const material = new THREE.MeshPhongMaterial({
    color: color,
    transparent: true,
    opacity: 0.5,
    emissive: color,
    emissiveIntensity: 0.2
  });
  
  const model = document.querySelector('model-viewer').model;
  if (!model) return;
  
  const mesh = model.getObjectByName(meshName);
  if (mesh) {
    mesh.material = material;
  }
}

// Function to reset highlighting
function resetHighlights() {
  const model = document.querySelector('model-viewer').model;
  if (!model) return;
  
  const defaultMaterial = new THREE.MeshPhongMaterial({
    color: 0xcccccc,
    transparent: false,
    opacity: 1.0
  });
  
  model.traverse((node) => {
    if (node.isMesh) {
      node.material = defaultMaterial;
    }
  });
}

// Function to handle muscle group hover
function onMuscleHover(meshName) {
  if (window.flutterChannel) {
    window.flutterChannel.postMessage(JSON.stringify({
      type: 'hover',
      meshName: meshName
    }));
  }
}

// Function to handle muscle group selection
function onMuscleSelect(meshName) {
  if (window.flutterChannel) {
    window.flutterChannel.postMessage(JSON.stringify({
      type: 'select',
      meshName: meshName
    }));
  }
}
