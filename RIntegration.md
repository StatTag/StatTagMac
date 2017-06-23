# R Framework Integration
When integrating the RCocoa framework into StatTag, we needed to make some adjustments to our projects:

## StatTagFramework

### General
* Linked Frameworks and Libraries -> Add `RCocoa.framework` and `R.framework`
	* References our custom R-wrapper framework and the actual R framework

### Build Settings
* Search Paths -> Header Search Paths -> Add `$(LOCAL_LIBRARY_DIR)/Frameworks/R.framework/Headers`
	* This is needed so that R.h can be found at compile time.
* Apple LLVM 8.0 - Language - Modules - Allow Non-moduler Includes in Framework Modules -> Change to `Yes`
	* This is needed so that the inclusion of the R framework compiles appropriately.

### Build Phases
* Link Binary With Libraries -> R.framework -> Change Status to `Optional`
	* Allows us to weakly link to the R framework (not required then if the user does not have R installed on their machine)


## StatTag
### General
* Linked Frameworks and Libraries -> Add `RCocoa.framework`
	* References our custom R-wrapper framework
	* Ensure this puts RCocoa.framework into Embedded Binaries as well