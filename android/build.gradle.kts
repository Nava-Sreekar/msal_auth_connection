allprojects {
    repositories {
        google()
        mavenCentral()
    }
      configurations.all {
        resolutionStrategy {
            force("io.opentelemetry:opentelemetry-api:1.32.0")
            force("io.opentelemetry:opentelemetry-context:1.32.0")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
