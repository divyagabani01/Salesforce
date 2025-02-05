// ldsUtils.js
/**
 * Given an error object, reduces it to a list of error messages.
 * @param {Object} error - The error object to reduce.
 * @returns {Array} - A list of error messages.
 */
export function reduceErrors(error) {
    let errors = [];
    if (Array.isArray(error.body)) {
        // Multiple errors
        errors = error.body.map(e => e.message);
    } else if (error.body && error.body.message) {
        // Single error
        errors = [error.body.message];
    } else {
        errors = ['Unknown error'];
    }
    return errors;
}