/**
 * @constructor
 */
function rayMarchingLayer(layer) {
  this.config = layer.config;
  this.shaderPass = new THREE.ShaderPass(SHADERS.rayMarching);

  this.cameraController = new CameraController(layer.type);
  this.cameraController.updateCamera(0);
  this.camera = this.cameraController.camera;

  this.shaderPass.uniforms.eye.value = this.camera.position;

  var vector = new THREE.Vector3( 0, 0, -1 );
  var forward = vector.applyQuaternion(this.camera.quaternion).normalize();
  this.shaderPass.uniforms.forward.value = forward;
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
  this.shaderPass.uniforms.eye.value = this.camera.position;

  var vector = new THREE.Vector3( 0, 0, -1 );
  var forward = vector.applyQuaternion(this.camera.quaternion).normalize();
  this.shaderPass.uniforms.forward.value = forward;
};

rayMarchingLayer.prototype.resize = function() {
};
