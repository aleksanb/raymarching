/**
 * @constructor
 */
function rayMarchingLayer(layer) {
  this.config = layer.config;
  this.shaderPass = new THREE.ShaderPass(SHADERS.rayMarching);

  this.cameraController = new CameraController(layer.type);
  this.cameraController.updateCamera(0);
  this.camera = this.cameraController.camera;

  this.shaderPass.uniforms.cameraPathPosition.value =
    this.camera.position;
}

rayMarchingLayer.prototype.getEffectComposerPass = function() {
  return this.shaderPass;
};

rayMarchingLayer.prototype.start = function() {
};

rayMarchingLayer.prototype.end = function() {
};

rayMarchingLayer.prototype.update = function(frame, relativeFrame) {
  this.shaderPass.uniforms.time.value = relativeFrame;
  this.cameraController.updateCamera(relativeFrame);
  this.shaderPass.uniforms.cameraPathPosition.value =
    this.camera.position;
};

rayMarchingLayer.prototype.resize = function() {
};
